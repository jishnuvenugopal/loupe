
module adder_subtractor_zero_flag (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire        subtract,
    output reg  [31:0] result,
    output reg         zero_flag
);

always @(*) begin
    if (subtract) begin
        result = a - b;
    end else begin
        result = a + b;
    end

    if (result == 0) begin
        zero_flag = 1;
    end else begin
        zero_flag = 0;
    end
end

endmodule
