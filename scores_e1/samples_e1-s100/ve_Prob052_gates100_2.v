
module TopModule (
    input  [99:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    
    assign out_and = in[99] & in[98] & ... & in[0];

    
    assign out_or = in[99] | in[98] | ... | in[0];

    
    assign out_xor = in[99] ^ in[98] ^ ... ^ in[0];

endmodule
