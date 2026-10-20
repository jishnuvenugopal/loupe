
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);


parameter S_A = 2'b01;
parameter S_B = 2'b10;


reg [1:0] state, next_state;


always @(posedge clk, posedge areset) begin
    if (areset)
        state <= S_A;
    else
        state <= next_state;
end


always @(*) begin
    case (state)
        S_A: next_state = x ? S_B : S_A;
        S_B: next_state = S_B;
        default: next_state = S_A;
    endcase
end


always @(*) begin
    case (state)
        S_A: z = x;
        S_B: z = ~x;
        default: z = 0;
    endcase
end

endmodule
