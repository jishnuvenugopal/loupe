
module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    
    assign byte0 = in[7:0];
    assign byte1 = in[15:8];
    assign byte2 = in[23:16];
    assign byte3 = in[31:24];

    
    assign reversed_byte0 = byte3;
    assign reversed_byte1 = byte2;
    assign reversed_byte2 = byte1;
    assign reversed_byte3 = byte0;

    
    assign out = reversed_byte3 << 24 | reversed_byte2 << 16 | reversed_byte1 << 8 | reversed_byte0;

endmodule
