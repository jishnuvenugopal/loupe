
module TopModule (
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

assign out[0] = in[(sel << 2) + 0];
assign out[1] = in[(sel << 2) + 1];
assign out[2] = in[(sel << 2) + 2];
assign out[3] = in[(sel << 2) + 3];

endmodule
