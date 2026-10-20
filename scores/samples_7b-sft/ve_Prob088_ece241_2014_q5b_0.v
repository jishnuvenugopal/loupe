
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] current_state, next_state;
localparam A = 2'b01;
localparam B = 2'b10;

always @(posedge clk or posedge areset) begin
    if (areset)
        current_state <= A;
    else
        current_state <= next_state;
end

always @(*) begin
    case (current_state)
        A: next_state = x ? B : A;
        B: next_state = B;
        default: next_state = A;
    endcase
end

assign z = (current_state[0] & x) | (current_state[1] & ~x);

endmodule
