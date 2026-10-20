
module div_16bit (input [15:0] A, input [7:0] B, output reg [15:0] result, output reg [15:0] odd);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    a_reg = A;
    b_reg = B;
    quotient = 0;
    remainder = 0;

    for (int i = 15;
 i >= 0;
 i--) begin
        remainder = {remainder[14:0], a_reg[15]};
 
        a_reg = a_reg << 1;
 

        if (remainder >= b_reg) begin
            quotient[i] = 1;
            remainder = remainder - b_reg;
        end
    end
end

assign result = quotient;
assign odd = remainder;

endmodule
