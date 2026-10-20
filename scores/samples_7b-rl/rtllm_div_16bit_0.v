
module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0] b_reg;
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [15:0] dividend_val;
    reg [7:0] divisor_val;
    integer i;

    
    always @ (A, B) begin
        a_reg = A;
        b_reg = B;
    end

    
    always @ (a_reg, b_reg) begin
        dividend_val = a_reg;
        divisor_val = b_reg;
        quotient = 16'd0;
        remainder = 16'd0;

        for (i = 15;
 i >= 0;
 i = i - 1) begin
            
            remainder = (remainder << 1) | ((dividend_val >> i) & 1);

            if (remainder >= divisor_val) begin
                quotient[i] = 1;
                remainder = remainder - divisor_val;
            end else begin
                quotient[i] = 0;
            end
        end

        
        result = quotient;
        odd = remainder;
    end

endmodule
