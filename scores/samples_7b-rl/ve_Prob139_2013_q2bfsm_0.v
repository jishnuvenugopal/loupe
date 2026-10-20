
module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [3:0] state, next_state;

localparam S_INIT  = 0,
           S_F     = 1,
           S_WAIT_X = 2,
           S_X1_WAIT = 3,
           S_X2_WAIT_0 =4,
           S_X3_WAIT_1 =5,
           S_G     =6,
           S_WAIT_1=7,
           S_WAIT_2=8,
           S_GOFF  =9;


always @(posedge clk) begin
    if (!resetn)
        state <= S_INIT;
    else
        state <= next_state;
end


always @* begin
    next_state = state;
    case (state)
        S_INIT: next_state = resetn ? S_F : S_INIT;
        S_F: next_state = S_WAIT_X;
        S_WAIT_X: next_state = x ? S_X1_WAIT : S_WAIT_X;
        S_X1_WAIT: next_state = x ? S_X1_WAIT : S_X2_WAIT_0;
        S_X2_WAIT_0: next_state = ~x ? S_X3_WAIT_1 : S_X1_WAIT;
        S_X3_WAIT_1: next_state = x ? S_G : S_X1_WAIT;
        S_G: next_state = S_WAIT_1;
        S_WAIT_1: next_state = y ? S_WAIT_1 : S_WAIT_2;
        S_WAIT_2: next_state = y ? S_WAIT_2 : S_GOFF;
        S_GOFF: next_state = S_GOFF;
        default: next_state = S_INIT;
    endcase
end


assign f = (state == S_F);
assign g = (state == S_G || state == S_WAIT_1 || state == S_WAIT_2);

endmodule
