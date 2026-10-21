
module TopModule (
    input wire [3:0] x,  
    input wire [3:0] y,  
    output reg [4:0] sum  
);


always @(posedge clk or negedge rst) begin
    if (~rst) begin
        sum <= 5'b00000;
    end else begin
        reg [3:0] carry = 4'b0;
        reg [3:0] temp_sum = 4'b0;

        for (int i = 0;
 i < 4;
 i++) begin
            temp_sum[i] = x[i] ^ y[i] ^ carry;
            carry = (x[i] & y[i]) | (x[i] & carry) | (y[i] & carry);
        end

        sum[4] = carry;
        sum[3:0] = temp_sum;
    end
end

endmodule
