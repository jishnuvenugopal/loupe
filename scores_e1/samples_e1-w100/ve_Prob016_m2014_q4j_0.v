
module TopModule (
    input wire [3:0] x,  
    input wire [3:0] y,  
    output reg [4:0] sum  
);


function reg [1:0] full_adder(input wire a, input wire b, input wire cin);
    assign full_adder[0] = a ^ b ^ cin;
    assign full_adder[1] = (a & b) | (a & cin) | (b & cin);
endfunction


always @(posedge clk or negedge rst) begin
    if (~rst) begin
        sum <= 5'b00000;
    end else begin
        reg [3:0] carry = 4'b0;
        reg [3:0] temp_sum = 4'b0;

        for (int i = 0;
 i < 4;
 i++) begin
            temp_sum[i] = full_adder(x[i], y[i], carry);
            carry = temp_sum[i][1];
        end

        
        sum[4] = carry;

        
        sum[3:0] <= temp_sum[3:0];
    end
end

endmodule
