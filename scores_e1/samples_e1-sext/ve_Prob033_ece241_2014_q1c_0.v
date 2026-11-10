
module TopModule (
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [7:0] s,
    output reg overflow
);

    
    reg [7:0] carry;
    reg [7:0] sum;

    
    always @(*) begin
        sum = a + b + carry;
        carry = sum[8];
 
    end

    
    always @(*) begin
        overflow = sum[7] && !carry;
 
    end

endmodule
