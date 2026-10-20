
module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg state;
wire next_state;

localparam OFF = 1'b0;
localparam ON = 1'b1;


always @(posedge clk) begin
    if (reset)
        state <= OFF;
    else
        state <= next_state;
end


assign next_state = (state == OFF) ? (j ? ON : OFF) : (k ? OFF : ON);


always @(*) begin
    out = state;
end

endmodule
