
module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

reg [63:0] next_Q;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= next_Q;
    end
end

always @(*) begin
    next_Q = Q;
    if (!rst_n) begin
        next_Q = 64'b0;
    end else begin
        if (Q[0] == 0) begin
            next_Q = {Q[63:1], 1'b1};
        end else begin
            next_Q = {Q[63:1], 1'b0};
        end
    end
end

endmodule
