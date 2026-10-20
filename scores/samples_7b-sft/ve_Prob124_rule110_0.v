
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;
wire [511:0] next_state;

genvar i;
generate
    for (i = 0;
 i < 512;
 i = i + 1) begin : gen_next_state
        wire left, center, right;
        assign left = (i == 0) ? 1'b0 : q_reg[i-1];
        assign center = q_reg[i];
        assign right = (i == 511) ? 1'b0 : q_reg[i+1];
        assign next_state[i] = (left & (center ^ right)) | (~left & (center | right));
    end
endgenerate

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule
