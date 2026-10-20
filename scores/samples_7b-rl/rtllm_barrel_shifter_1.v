
module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

wire [7:0] shifted4_out;
 
wire [7:0] shifted2_out;
wire [7:0] shifted1_out;

mux2X1 mux_shift4 (
    .out(shifted4_out),
    .in0(in),
    .in1({4'b0000, in[7:4]}),
    .sel(ctrl[2])
);

mux2X1 mux_shift2 (
    .out(shifted2_out),
    .in0(shifted4_out),
    .in1({2'b00, shifted4_out[7:2]}),
    .sel(ctrl[1])
);

mux2X1 mux_shift1 (
    .out(shifted1_out),
    .in0(shifted2_out),
    .in1({1'b0, shifted2_out[7:1]}),
    .sel(ctrl[0])
);

assign out = shifted1_out;

endmodule

module mux2X1 (
    output [7:0] out,
    input [7:0] in0,
    input [7:0] in1,
    input sel
);

assign out = sel ? in1 : in0;

endmodule
