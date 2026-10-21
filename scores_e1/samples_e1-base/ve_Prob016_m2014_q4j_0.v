
module TopModule (
    input wire [3:0] x,  
    input wire [3:0] y,  
    output reg [4:0] sum  
);


function reg [3:0] full_adder(input wire a, input wire b, input wire cin);
    assign reg [3:0] sum = a ^ b ^ cin;
    assign reg [3:0] carry = (a & b) | (b & cin) | (a & cin);
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
            temp_sum = full_adder(x[i], y[i], carry);
            carry = temp_sum[3];
            sum[i] = temp_sum[2:0];
        end

        
        sum[4] = carry;
    end
end

endmodule
