
module TopModule (
    input [31:0] in,
    output [31:0] out
);

    wire [7:0] byte0, byte1, byte2, byte3, byte4, byte5, byte6, byte7;

    assign byte0 = in[7:0];
    assign byte1 = in[15:8];
    assign byte2 = in[23:16];
    assign byte3 = in[31:24];
    assign byte4 = in[7:0];
    assign byte5 = in[15:8];
    assign byte6 = in[23:16];
    assign byte7 = in[31:24];

    assign out[31:24] = byte0;
    assign out[23:16] = byte1;
    assign out[15:8] = byte2;
    assign out[7:0] = byte3;
    assign out[31:24] = byte4;
    assign out[23:16] = byte5;
    assign out[15:8] = byte6;
    assign out[7:0] = byte7;

endmodule
