
module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;


always @* begin
    a_reg = A;
    b_reg = B;
end


reg [15:0] quotient;
reg [15:0] remainder;
integer i;


always @* begin
    quotient = 16'd0;
    remainder = 16'd0;

    for (i = 15;
 i >= 0;
 i = i - 1) begin
        
        remainder = (remainder << 1) | (a_reg[i] ? 1 : 0);

        if (remainder >= {8'd0, b_reg}) begin
            remainder = remainder - {8'd0, b_reg};
            quotient[i] = 1;
        end else begin
            quotient[i] = 0;
        end
    end

    result = quotient;
    odd = remainder;
end

endmodule
