
module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output reg [15:0] y,
    output reg Co
);

    
    always @(posedge Cin or negedge a or negedge b) begin
        reg [7:0] sum;
        reg [7:0] carry;

        
        sum = a[7:0] + b[7:0];
        carry = sum[8];

        
        sum = sum[7:0] + b[7:0];
        carry = sum[8];

        
        sum = sum[7:0] + b[7:0];
        carry = sum[8];

        
        sum = sum[7:0] + b[7:0];
        carry = sum[8];

        
        sum = sum[7:0] + b[7:0];
        carry = sum[8];

        
        sum = sum[7:0] + b[7:0];
        carry = sum[8];

        
        sum = sum[7:0] + b[7:0];
        carry = sum[8];

        
        sum = sum[7:0] + b[7:0];
        carry = sum[8];

        
        y = sum[7:0];
        Co = carry;
    end

endmodule
