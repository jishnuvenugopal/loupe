
module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output reg  [24:0] out
);

    
    generate
        for (genvar i = 0;
 i < 25;
 i = i + 1) begin : output_bit_gen
            
            assign out[i] = (~a ^ b) | (~a ^ c) | (~a ^ d) | (~a ^ e) | (~b ^ c) | (~b ^ d) | (~b ^ e) | (~c ^ d) | (~c ^ e) | (~d ^ e);
        end
    endgenerate

endmodule
