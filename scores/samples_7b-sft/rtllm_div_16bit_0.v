
module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg, b_reg;
integer i;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] quotient = 0;
    reg [15:0] remainder = 0;
    reg [7:0] divisor = b_reg;

    for (i = 15;
 i >= 0;
 i = i - 1) begin
        remainder = (remainder << 1) | ((a_reg >> i) & 1);
        if (remainder >= divisor) begin
            remainder = remainder - divisor;
            quotient = (quotient << 1) | 1;
        end else begin
            quotient = (quotient << 1) | 0;
        end
    end

    result = quotient;
    odd = remainder;
end

endmodule
