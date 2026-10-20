
module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0] b_reg;
    reg [15:0] quotient;
    reg [15:0] remainder;

    always @ (A or B) begin
        a_reg <= A;
        b_reg <= B;
    end

    always @ (A or B) begin
        if (a_reg >= b_reg) begin
            quotient <= quotient | 16'b1;
            remainder <= a_reg - b_reg;
        end else begin
            quotient <= quotient | 16'b0;
            remainder <= a_reg;
        end
        a_reg <= a_reg >> 8;
    end

    always @ (A or B) begin
        if (a_reg >= b_reg) begin
            result <= result | 16'b1;
            odd <= a_reg - b_reg;
        end else begin
            result <= result | 16'b0;
            odd <= a_reg;
        end
        a_reg <= a_reg >> 8;
    end

endmodule
