
module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    
    assign out_both[99] = 1'b0;
 
    assign out_both[98:0] = in[98:0] & in[99:99];

    
    assign out_any[0] = 1'b0;
 
    assign out_any[99:1] = in[99:1] | in[100:100];

    
    assign out_different[0] = in[0] ^ in[99];
 
    assign out_different[99:1] = in[99:1] ^ in[100:100];

endmodule
