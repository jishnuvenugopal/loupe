
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out_sop,
    output reg out_pos
);

    
    reg [3:0] xor_products;

    
    reg [3:0] xor_sums;

    
    assign xor_products = a ^ b ^ c ^ d;

    
    assign xor_sums = xor_products[0] ^ xor_products[1] ^ xor_products[2] ^ xor_products[3];

    
    assign out_sop = xor_sums[0] | xor_sums[1] | xor_sums[2] | xor_sums[3];

    
    assign out_pos = xor_products[0] & xor_products[1] & xor_products[2] & xor_products[3];

endmodule
