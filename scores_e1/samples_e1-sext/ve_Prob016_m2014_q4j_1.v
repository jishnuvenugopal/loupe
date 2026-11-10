
module TopModule (
    input wire [3:0] x,
    input wire [3:0] y,
    output reg [4:0] sum
);

always @(*) begin
    reg [3:0] carry = 0;
    reg [4:0] sum_temp = 0;

    
    for (int i = 0;
 i < 4;
 i++) begin
        sum_temp[i] = x[i] ^ y[i] ^ carry;
        carry = (x[i] & y[i]) | (x[i] & carry) | (y[i] & carry);
    end

    
    sum = sum_temp[3] << 3 | sum_temp[2] << 2 | sum_temp[1] << 1 | sum_temp[0];
    sum[4] = carry;

end

endmodule
