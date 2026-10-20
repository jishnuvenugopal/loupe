
module TopModule(
    input [2:0] in,
    output reg [1:0] out
);

    wire [2:0] count;
    assign count = in[0] + in[1] + in[2];
    assign out = count;

endmodule
