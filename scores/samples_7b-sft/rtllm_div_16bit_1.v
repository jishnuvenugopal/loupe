
module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    integer i;
    reg [15:0] temp_result;
    reg [15:0] temp_remainder;

    temp_result = 16'b0;
    temp_remainder = 16'b0;

    for (i = 15;
 i >= 0;
 i = i - 1) begin
        temp_remainder = {temp_remainder[14:0], a_reg[i]};
        if (temp_remainder >= {8'b0, b_reg}) begin
            temp_remainder = temp_remainder - {8'b0, b_reg};
            temp_result[i] = 1'b1;
        end else begin
            temp_result[i] = 1'b0;
        end
    end

    result = temp_result;
    odd = temp_remainder;
end

endmodule
