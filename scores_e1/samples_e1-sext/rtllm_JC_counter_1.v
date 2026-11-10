
module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

reg [63:0] next_Q;

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        Q <= 64'b0;
    end else begin
        next_Q <= Q;
        if (Q[0] == 1'b0) begin
            next_Q <= next_Q >> 1 | 64'b1;
        end else begin
            next_Q <= next_Q >> 1;
        end
    end
end

assign Q = next_Q;

endmodule
