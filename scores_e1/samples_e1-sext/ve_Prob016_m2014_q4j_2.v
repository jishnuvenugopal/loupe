
module TopModule (
    input wire [3:0] x,  
    input wire [3:0] y,  
    output reg [4:0] sum, 
    output reg overflow 
);


always @(*) begin
    reg [3:0] carry = 0;
    reg [4:0] temp_sum = 0;

    
    for (int i = 0;
 i < 4;
 i++) begin
        temp_sum[i] = x[i] ^ y[i] ^ carry;
        carry = (x[i] & y[i]) | (carry & (x[i] ^ y[i]));
    end

    
    overflow = (temp_sum[4] == 1);

    
    sum = temp_sum;
end

endmodule
