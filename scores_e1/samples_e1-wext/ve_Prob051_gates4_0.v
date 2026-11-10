
module TopModule (
    input wire [3:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    
    assign out_and = in[0] & in[1] & in[2] & in[3];

    
    assign out_or = in[0] | in[1] | in[2] | in[3];

    
    assign out_xor = in[0] ^ in[1] ^ in[2] ^ in[3];

endmodule
