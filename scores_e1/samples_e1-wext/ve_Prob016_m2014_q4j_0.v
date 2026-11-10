
module TopModule (
    input wire [3:0] x,
    input wire [3:0] y,
    output reg [4:0] sum
);

    always @(*) begin
        reg [3:0] carry = 0;
        reg [4:0] temp_sum = 0;

        
        temp_sum = x + y;

        
        if (temp_sum[4]) begin
            carry = 1;
            temp_sum = temp_sum - 1;
 
        end

        
        sum = temp_sum;
    end

endmodule
