
module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg signed [63:0] shift_reg;

always @(posedge clk) begin
    if (load)
        shift_reg <= data;
    else if (ena) begin
        case (amount)
            2'b00: shift_reg <= shift_reg << 1;
            2'b01: shift_reg <= shift_reg << 8;
            2'b10: shift_reg <= shift_reg >>> 1;
            2'b11: shift_reg <= shift_reg >>> 8;
            default: shift_reg <= shift_reg;
        endcase
    end
end

assign q = shift_reg;

endmodule
