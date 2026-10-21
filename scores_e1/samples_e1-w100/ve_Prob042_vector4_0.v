
module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    
    assign sign_bit = in[7];

    
    assign out = sign_bit << 24 | in;

endmodule
