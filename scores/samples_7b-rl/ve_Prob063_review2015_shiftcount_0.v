
module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q = 0
);

reg [3:0] next_state;

always @(posedge clk) begin
    if (shift_ena) begin
        next_state = {data, q[3:1]};
        if (count_ena)
            next_state = next_state - 1;
    end
    else begin
        next_state = q;
        if (count_ena)
            next_state = next_state - 1;
    end
    q <= next_state;
end

endmodule
