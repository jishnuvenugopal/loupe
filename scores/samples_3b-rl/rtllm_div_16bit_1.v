
module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0] b_reg;
    reg [7:0] quotient;
    reg [7:0] odd_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    always @(*) begin
        if (a_reg[15:8] > b_reg) begin
            quotient[7] = 1;
        end else begin
            quotient[7] = 0;
        end
        if (a_reg[15:8] > b_reg) begin
            odd_reg[7] = a_reg[15:8] - b_reg;
        end else begin
            odd_reg[7] = 0;
        end
    end

    always @(*) begin
        if (a_reg[7:0] > b_reg) begin
            quotient[6] = 1;
        end else begin
            quotient[6] = 0;
        end
        if (a_reg[7:0] > b_reg) begin
            odd_reg[6] = a_reg[7:0] - b_reg;
        end else begin
            odd_reg[6] = 0;
        end
    end

    always @(*) begin
        result = {quotient[7:0], quotient[6:0]};
        odd = {odd_reg[7:0], odd_reg[6:0]};
    end

endmodule
