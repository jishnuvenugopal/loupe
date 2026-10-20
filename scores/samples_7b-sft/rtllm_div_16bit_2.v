
module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
integer i;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    result = 16'b0;
    odd = 16'b0;
    if (b_reg == 0) begin
        
    end else begin
        reg [7:0] remainder;
        reg [7:0] divisor = b_reg;
        remainder = 8'b0;
        for (i = 15;
 i >= 0;
 i = i - 1) begin
            remainder = (remainder << 1) | ((a_reg >> i) & 1);
            if (remainder >= divisor) begin
                remainder = remainder - divisor;
                result[i] = 1;
            end else begin
                result[i] = 0;
            end
        end
        odd = {remainder, 8'b0};
    end
end

endmodule
