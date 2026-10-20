
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state_reg;
localparam A = 2'b01;
localparam B = 2'b10;


reg [1:0] next_state;

always @(*) begin
    case (state_reg)
        A: next_state = x ? B : A;
        B: next_state = B;
        default: next_state = A;
    endcase
end


always @(posedge clk or posedge areset) begin
    if (areset)
        state_reg <= A;
    else
        state_reg <= next_state;
end


assign z = (state_reg == A) ? x : ~x;

endmodule
