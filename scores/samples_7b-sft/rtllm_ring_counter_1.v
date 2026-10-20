
module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state_reg;
wire [7:0] next_state;

assign next_state = (state_reg << 1) | (state_reg >> 7);
assign out = state_reg;

always @(posedge clk) begin
    if (reset)
        state_reg <= 8'b00000001;
    else
        state_reg <= next_state;
end

endmodule
