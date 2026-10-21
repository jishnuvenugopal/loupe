
module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

reg [63:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 64'b0;
    end else begin
        if (shift_reg[0] == 0) begin
            shift_reg <= {shift_reg[63:1], 1'b1};
        end else begin
            shift_reg <= {shift_reg[63:1], 1'b0};
        end
    end
end

assign Q = shift_reg;

endmodule
