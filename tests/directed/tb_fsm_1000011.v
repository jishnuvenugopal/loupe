// Directed check: the RTLLM fsm spec matches 1,0,0,1,1 only. Input 1,0,0,0,0,1,1 must NOT raise MATCH.
// Build: rename the reference module to `gold` and the candidate to `gate`, then iverilog -g2012 gold.v gate.v tb_fsm_1000011.v
module tb; reg CLK=0, RST=1, IN=0; wire mg, mt; integer i; reg [6:0] seq = 7'b1000011;
gold g(.CLK(CLK),.RST(RST),.IN(IN),.MATCH(mg)); gate t(.CLK(CLK),.RST(RST),.IN(IN),.MATCH(mt));
always #5 CLK=~CLK;
initial begin @(posedge CLK); @(posedge CLK); #1 RST=0;
 for (i=6;i>=0;i=i-1) begin IN=seq[i]; #2 $display("IN=%b  MATCH gold=%b gate=%b", IN, mg, mt); @(posedge CLK); #1; end $finish; end endmodule
// Result 17 Oct 2026 (GPT-4 trial t2): last line "IN=1  MATCH gold=0 gate=1" -> the candidate matches a sequence the spec rejects.
