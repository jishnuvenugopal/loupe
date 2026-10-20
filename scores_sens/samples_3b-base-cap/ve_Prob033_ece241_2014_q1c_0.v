
module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    
    reg [8:0] sum;
    reg [8:0] carry;

    
    always @(*) begin
        sum = a + b;
        carry = sum[8];
 
    end

    
    assign overflow = (a[7] ^ b[7]) & (a[7] ^ sum[7]);

    
    assign s = sum[7:0];

endmodule
