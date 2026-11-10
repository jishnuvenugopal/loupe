
module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    
    assign sign_bits = {24'b0, in};

    
    assign out = sign_bits;

endmodule
