
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

wire [511:0] next_state;

genvar i;
generate
    for (i = 0;
 i < 512;
 i = i + 1) begin : gen_next_state
        wire left_bit = (i == 0) ? 1'b0 : q[i-1];
        wire center_bit = q[i];
        wire right_bit = (i == 511) ? 1'b0 : q[i+1];
        wire [1:0] sum = left_bit + center_bit + right_bit;
        assign next_state[i] = (sum == 1 || sum == 2) ? 1'b1 : 1'b0;
    end
endgenerate

always @(posedge clk) begin
    if (load)
        q <= data;
    else
        q <= next_state;
end

endmodule
