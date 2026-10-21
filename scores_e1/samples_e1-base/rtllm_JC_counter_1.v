
module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

    reg [63:0] shift_reg;
    reg [63:0] next_shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 64'b0;
            next_shift_reg <= 64'b0;
        end else begin
            next_shift_reg <= {shift_reg[62:0], shift_reg[63], 1'b0};
            Q <= next_shift_reg;
        end
    end

endmodule
