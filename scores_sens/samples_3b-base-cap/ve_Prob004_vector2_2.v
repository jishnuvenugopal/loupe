
module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    
    reg [7:0] byte0, byte1, byte2, byte3;

    
    byte0 = in[7:0];
    byte1 = in[15:8];
    byte2 = in[23:16];
    byte3 = in[31:24];

    
    out[31:24] = byte0;
    out[23:16] = byte1;
    out[15:8] = byte2;
    out[7:0] = byte3;

endmodule
