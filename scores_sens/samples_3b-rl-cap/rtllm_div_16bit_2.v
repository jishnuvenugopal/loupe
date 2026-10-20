
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
        if (a_reg[15:8] >= b_reg) begin
            quotient[15:8] <= 1;
            remainder[15:8] <= a_reg[15:8] - b_reg;
        end else begin
            quotient[15:8] <= 0;
            remainder[15:8] <= a_reg[15:8];
        end
        if (a_reg[7:0] >= b_reg) begin
            quotient[7:0] <= 1;
            remainder[7:0] <= a_reg[7:0] - b_reg;
        end else begin
            quotient[7:0] <= 0;
            remainder[7:0] <= a_reg[7:0];
        end
        if (a_reg[0] >= b_reg) begin
            quotient[0] <= 1;
            remainder[0] <= a_reg[0] - b_reg;
        end else begin
            quotient[0] <= 0;
            remainder[0] <= a_reg[0];
        end
    end

    always @ (A or B) begin
        result <= quotient;
        odd <= remainder;
    end

endmodule
