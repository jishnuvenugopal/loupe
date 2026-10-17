"""D4 spec oracle v2: each property directly formalizes the pilot's narrative
finding about a spec sentence in design_description.txt. Verdicts come from
solvers (abc pdr prove / smtbmc cover), with counterexample traces on disk.

accu        spec: "only valid_in samples accumulate; groups of four" ->
            directed stimulus [invalid 100; valid 1,2,3,4]; assert no valid_out
            pulse with data_out != 10 (reference pulses 106 = 100+1+2+3).
width_8to16 spec: "valid_out lasts one cycle" -> assert no back-to-back pulses.
LIFObuffer  spec: "reset empties the stack" -> fill 4, reset, assert !FULL.
fsm         spec: "MATCH only for 1,0,0,1,1" -> drive 1,0,0,0,0,1,1, assert !MATCH.
square_wave spec: "wave_out toggles" -> COVER wave_out=1 reachable; the F.6
            constant-0 mutant makes it UNREACHABLE while the official TB passes.
"""
import os, sys, re, json, shutil, glob
sys.path.insert(0, os.path.dirname(__file__))
import common as C

WORKROOT = os.path.expanduser("~/runs/deep/spec")
PRE = "proc; flatten; memory_map; tribuf -logic; opt_clean; async2sync; setundef -zero -init; "

def prep(name, subject="reference"):
    c = glob.glob(os.path.join(C.RTLLM, "*", "*", name))
    d = c[0]
    work = os.path.join(WORKROOT, f"{name}_{subject}")
    shutil.rmtree(work, ignore_errors=True); os.makedirs(work)
    top = C.prep_design_src(d, work)
    return work, top

def subject_file(work, gen):
    if gen:
        shutil.copy(gen, os.path.join(work, "subj.v"))
        return "subj.v"
    return "ref.v"

def sby_prop(work, tag, files, script, mode="prove", timeout=300, engine=None):
    if engine is None:
        engine = "abc pdr" if mode == "prove" else "smtbmc"
    tdir = os.path.join(work, f"sby_{tag}")
    shutil.rmtree(tdir, ignore_errors=True)
    sby = f"[options]\nmode {mode}\n\n[engines]\n{engine}\n\n[script]\n{script}\n\n[files]\n"
    sby += "\n".join(os.path.join(work, f) for f in files) + "\n"
    sp = os.path.join(work, f"{tag}.sby")
    open(sp, "w").write(sby)
    rc, out = C.run(["sby", "-f", "-d", tdir, sp], work, timeout)
    logf = os.path.join(tdir, "logfile.txt")
    txt = open(logf).read() if os.path.exists(logf) else out
    if "DONE (PASS," in txt or "Status: PASS" in txt:
        st = "PASS"
    elif "DONE (FAIL," in txt or "Status: FAIL" in txt:
        st = "FAIL"
    elif "DONE (UNKNOWN" in txt:
        st = "UNKNOWN"
    else:
        st = "TIMEOUT" if rc == "timeout" else "ERROR"
    return st, tdir

# ---- property sources (one per audited spec sentence) ----

ACCU_PROP = r"""
module accu_spec_prop(input clk);
  reg rst_n = 1'b0; reg [7:0] data_in = 8'd0; reg valid_in = 1'b0;
  reg [3:0] t = 4'd0;
  always @(posedge clk) begin
    case (t)
      4'd1: rst_n <= 1'b1;
      4'd3: begin data_in <= 8'd100; valid_in <= 1'b0; end  // INVALID sample
      4'd4: begin data_in <= 8'd1;   valid_in <= 1'b1; end
      4'd5: data_in <= 8'd2;
      4'd6: data_in <= 8'd3;
      4'd7: data_in <= 8'd4;
      4'd8: valid_in <= 1'b0;
    endcase
    if (t < 4'd14) t <= t + 4'd1;
  end
  accu dut(.clk(clk), .rst_n(rst_n), .data_in(data_in), .valid_in(valid_in),
           .valid_out(v), .data_out(d));
  wire v; wire [9:0] d;
  // SPEC: groups of four VALID samples; 1+2+3+4 = 10. No pulse may carry
  // any other sum (the invalid 100 must not contribute).
  always @(posedge clk) if (t >= 4'd5) assert (!(v && d != 10'd10));
endmodule
"""

W816_PROP = r"""
module w816_prop(input clk, input rst_n, input valid_in, input [7:0] data_in);
  reg [2:0] t = 3'd0;
  always @(posedge clk) if (t < 3'd4) t <= t + 3'd1;
  wire rst_eff = (t < 3'd2) ? 1'b0 : rst_n;
  width_8to16 dut(.clk(clk), .rst_n(rst_eff), .valid_in(valid_in),
                  .data_in(data_in), .valid_out(v), .data_out(d));
  wire v; wire [15:0] d;
  // SPEC: valid_out lasts one cycle.
  always @(posedge clk) if (t >= 3'd3) assert (!(v && $past(v)));
endmodule
"""

LIFO_PROP = r"""
module lifo_prop(input [3:0] dataIn, input RW, input Clk);
  reg [3:0] t = 4'd0; reg Rst = 1'b1; reg EN = 1'b1;
  always @(posedge Clk) begin
    case (t)
      4'd2, 4'd3, 4'd4, 4'd5: begin Rst <= 1'b0; RW <= 1'b0; end // 4 pushes
      4'd6: Rst <= 1'b1;                                         // reset while full
      4'd7: begin Rst <= 1'b0; RW <= 1'b1; end                   // read mode
    endcase
    if (t < 4'd10) t <= t + 4'd1;
  end
  LIFObuffer dut(.dataIn(dataIn), .dataOut(q), .RW(RW), .EN(EN), .Rst(Rst),
                 .EMPTY(e), .FULL(f), .Clk(Clk));
  wire [3:0] q; wire e, f;
  // SPEC: reset empties the stack -> FULL must be low after the reset pulse.
  always @(posedge Clk) if (t == 4'd7 || t == 4'd8) assert (!f);
endmodule
"""

FSM_PROP = r"""
module fsm_prop(input CLK);
  reg [3:0] t = 4'd0;
  reg [6:0] seq = 7'b1000011;                     // forbidden sequence, MSB first
  always @(posedge CLK) if (t < 4'd15) t <= t + 4'd1;
  wire IN = (t < 4'd2) ? 1'b0 : seq[6 - ((t - 4'd2) > 4'd6 ? 4'd6 : (t - 4'd2))];
  wire RST = (t < 4'd2) ? 1'b1 : 1'b0;
  fsm dut(.IN(IN), .MATCH(m), .CLK(CLK), .RST(RST));
  wire m;
  // SPEC: only 1,0,0,1,1 raises MATCH; 1,0,0,0,0,1,1 must not.
  always @(posedge CLK) if (t >= 4'd2 && t <= 4'd13) assert (!m);
endmodule
"""

SQW_PROP = r"""
module sqw_prop(input clk, input [7:0] freq);
  reg [2:0] t = 3'd0;
  always @(posedge clk) if (t < 3'd3) t <= t + 3'd1;
  square_wave dut(.clk(clk), .freq(freq), .wave_out(w));
  wire w;
  // SPEC: wave_out is a square wave -> a cycle with wave_out=1 is reachable.
  always @(posedge clk) if (t >= 3'd3) cover(w);
endmodule
"""

def run_case(name, prop_src, prop_file, top_canon, prop_top, mode, subject, gen=None, engine=None):
    work, top = prep(name, subject)
    sf = subject_file(work, gen)
    open(os.path.join(work, prop_file), "w").write(prop_src)
    script = (f"read_verilog -sv {sf}; hierarchy -top {top}; {PRE}rename {top} {top_canon}; design -stash d0;\n"
              f"read_verilog -sv -formal {prop_file}; design -copy-from d0 -as {top_canon} {top_canon}; "
              f"prep -top {prop_top}; setundef -zero -init; opt_clean")
    st, tdir = sby_prop(work, prop_file[:-3], [sf, prop_file], script, mode=mode, engine=engine)
    return {"case": name, "subject": subject, "status": st, "evidence": tdir}

if __name__ == "__main__":
    R = os.path.expanduser("~/bench/RTLLM")
    os.makedirs(WORKROOT, exist_ok=True)
    out = []
    out.append({"spec_property": "accu: only valid samples accumulate (groups of 4)",
                **run_case("accu", ACCU_PROP, "accu_prop.sv", "accu", "accu_spec_prop", "prove", "reference")})
    out.append({"spec_property": "width_8to16: valid_out is a one-cycle pulse",
                **run_case("width_8to16", W816_PROP, "w816_prop.sv", "width_8to16", "w816_prop", "prove", "reference")})
    out.append({"spec_property": "width_8to16: same, on the GPT-4 t1 design",
                **run_case("width_8to16", W816_PROP, "w816_prop.sv", "width_8to16", "w816_prop", "prove", "gpt4t1",
                           gen=R + "/_chatgpt4/t1/width_8to16.v")})
    out.append({"spec_property": "LIFObuffer: reset-while-full drops FULL",
                **run_case("LIFObuffer", LIFO_PROP, "lifo_prop.sv", "LIFObuffer", "lifo_prop", "prove", "reference", engine="smtbmc")})
    out.append({"spec_property": "fsm: sequence 1000011 must not MATCH",
                **run_case("fsm", FSM_PROP, "fsm_prop.sv", "fsm", "fsm_prop", "prove", "reference", engine="smtbmc")})
    out.append({"spec_property": "fsm: same, on the GPT-4 t2 design",
                **run_case("fsm", FSM_PROP, "fsm_prop.sv", "fsm", "fsm_prop", "prove", "gpt4t2",
                           gen=R + "/_chatgpt4/t2/fsm.v", engine="smtbmc")})
    out.append({"spec_property": "square_wave: cover wave_out=1 reachable (vacuity)",
                **run_case("square_wave", SQW_PROP, "sqw_prop.sv", "square_wave", "sqw_prop", "cover", "reference")})
    # the F.6 constant-0 mutant: same cover must be UNREACHABLE
    mutdir = os.path.join(WORKROOT, "square_wave_mut")
    shutil.rmtree(mutdir, ignore_errors=True); os.makedirs(mutdir)
    shutil.copy(os.path.expanduser("~/bench/RTLLM/Miscellaneous/Others/square_wave/testbench.v"),
                os.path.join(mutdir, "tb.v")) if False else None
    d = glob.glob(os.path.join(C.RTLLM, "*", "*", "square_wave"))[0]
    shutil.copy(os.path.join(d, "testbench.v"), os.path.join(mutdir, "tb.v"))
    open(os.path.join(mutdir, "ref.v"), "w").write(
        "module square_wave(input clk, input [7:0] freq, output reg wave_out);\n"
        "  initial wave_out = 1'b0;\n  always @(posedge clk) wave_out <= 1'b0;\nendmodule\n")
    open(os.path.join(mutdir, "sqw_prop.sv"), "w").write(SQW_PROP)
    script = ("read_verilog -sv ref.v; hierarchy -top square_wave; " + PRE +
              "rename square_wave square_wave; design -stash d0;\n"
              "read_verilog -sv sqw_prop.sv; design -copy-from d0 -as square_wave square_wave; prep -top sqw_prop")
    st, tdir = sby_prop(mutdir, "sqw_prop", ["ref.v", "sqw_prop.sv"], script, mode="cover")
    out.append({"case": "square_wave", "subject": "const0-mutant(F.6)",
                "spec_property": "cover wave_out=1 reachable (vacuity)", "status": st, "evidence": tdir})
    # and the official TB verdict on the mutant (the vacuity the pilot found)
    tb = C.tb_verdict(mutdir, "ref.v", "tb.v", "mut")
    out.append({"case": "square_wave", "subject": "const0-mutant(F.6)",
                "spec_property": "official testbench verdict on the same mutant", "status": "TB " + tb,
                "evidence": mutdir})
    json.dump(out, open(os.path.join(WORKROOT, "spec_results.json"), "w"), indent=1)
    for r in out:
        print(json.dumps(r))
