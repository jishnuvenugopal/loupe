
module TopModule (
    input wire [3:0] x,  
    input wire [3:0] y,  
    output reg [4:0] sum, 
    output reg overflow  
);


reg [1:0] full_adder(input wire a, input wire b, input wire cin, output reg sum, output reg carry);

always @(a, b, cin) begin
    sum = a ^ b ^ cin;
    carry = (a & b) | (b & cin) | (a & cin);
end


reg [3:0] carry_in = 0;
 
reg [3:0] sum_out;
     

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sum_out <= 0;
        carry_in <= 0;
        overflow <= 0;
    end else begin
        sum_out <= sum_out + carry_in;
        carry_in <= full_adder(x[3], y[3], carry_in);
        sum_out <= sum_out + carry_in;
        carry_in <= full_adder(x[2], y[2], carry_in);
        sum_out <= sum_out + carry_in;
        carry_in <= full_adder(x[1], y[1], carry_in);
        sum_out <= sum_out + carry_in;
        carry_in <= full_adder(x[0], y[0], carry_in);
        overflow <= carry_in;
    end
end


assign sum = sum_out;
assign overflow = overflow;

endmodule
