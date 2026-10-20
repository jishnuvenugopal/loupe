
module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    
    wire mux1_out, mux2_out, mux3_out;
    mux2to1 mux1(.sel(d), .a(c), .b(1'b0), .out(mux1_out));
    mux2to1 mux2(.sel(d), .a(1'b0), .b(d), .out(mux2_out));
    mux2to1 mux3(.sel(c), .a(mux1_out), .b(mux2_out), .out(mux_in[0]));

    
    wire mux4_out;
    mux2to1 mux4(.sel(c), .a(d), .b(1'b0), .out(mux4_out));
    assign mux_in[1] = mux4_out;

    
    wire mux5_out, mux6_out, mux7_out, mux8_out;
    mux2to1 mux5(.sel(c), .a(~d), .b(1'b0), .out(mux5_out));
    mux2to1 mux6(.sel(~c), .a(~d), .b(1'b0), .out(mux6_out));
    mux2to1 mux7(.sel(c ^ d), .a(mux5_out), .b(mux6_out), .out(mux7_out));
    assign mux_in[2] = mux7_out;

    
    wire mux8_out;
    mux2to1 mux8(.sel(d), .a(1'b1), .b(1'b0), .out(mux8_out));
    assign mux_in[3] = mux8_out;
endmodule


module mux2to1(sel, a, b, out);
    input sel, a, b;
    output out;
    assign out = sel ? b : a;
endmodule


module mux4to1(sel, in0, in1, in2, in3, out);
    input [1:0] sel;
    input in0, in1, in2, in3;
    output out;
    assign out = sel[1] ? (sel[0] ? in3 : in2) : (sel[0] ? in1 : in0);
endmodule
