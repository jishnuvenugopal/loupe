
module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;
reg [511:0] next_state;
integer idx;
reg left, center, right;

always @* begin
    for (idx = 0;
 idx < 512;
 idx = idx + 1) begin
        
        left = (idx == 0) ? 1'b0 : q_reg[idx-1];
        
        center = q_reg[idx];
        
        right = (idx == 511) ? 1'b0 : q_reg[idx+1];
        
        case ({left, center, right})
            3'b111: next_state[idx] = 1'b0;
            3'b110: next_state[idx] = 1'b1;
            3'b101: next_state[idx] = 1'b1;
            3'b100: next_state[idx] = 1'b0;
            3'b011: next_state[idx] = 1'b1;
            3'b010: next_state[idx] = 1'b1;
            3'b001: next_state[idx] = 1'b1;
            3'b000: next_state[idx] = 1'b0;
            default: next_state[idx] = 1'b0;
        endcase
    end
end


always @(posedge clk) begin
    if (load)
        q_reg <= data;
    else
        q_reg <= next_state;
end

assign q = q_reg;

endmodule
