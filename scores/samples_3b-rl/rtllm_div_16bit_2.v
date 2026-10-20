
module div_16bit (
    input  wire [15:0] A,
    input  wire [ 7:0] B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [ 7:0] b_reg;

    integer i;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    always @(*) begin
        result = 16'b0;
        odd = 16'b0;

        for (i = 0;
 i < 2;
 i = i + 1) begin
            if (a_reg[15:8] > b_reg) begin
                result[15-i] = 1'b1;
            end
            odd = a_reg[15:8] - b_reg;
            a_reg = a_reg[7:0];
        end

        for (i = 0;
 i < 2;
 i = i + 1) begin
            if (a_reg[7:0] > b_reg) begin
                result[15-i-2] = 1'b1;
            end
            odd = a_reg[7:0] - b_reg;
            a_reg = a_reg[0];
        end
    end

endmodule
