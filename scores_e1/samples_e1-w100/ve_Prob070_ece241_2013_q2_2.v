
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

    
    xor_products[0] = a ^ b ^ c ^ d;
    xor_products[1] = a ^ b ^ c ^ ~d;
    xor_products[2] = a ^ b ^ ~c ^ d;
    xor_products[3] = a ^ b ^ ~c ^ ~d;

    
    xor_sums[0] = xor_products[0] ^ xor_products[1];
    xor_sums[1] = xor_products[0] ^ xor_products[2];
    xor_sums[2] = xor_products[0] ^ xor_products[3];
    xor_sums[3] = xor_products[1] ^ xor_products[2] ^ xor_products[3];

    
    out_sop = xor_sums[0] ^ xor_sums[1] ^ xor_sums[2] ^ xor_sums[3];

    
    out_pos = xor_products[0] & xor_products[1] & xor_products[2] & xor_products[3];

endmodule
