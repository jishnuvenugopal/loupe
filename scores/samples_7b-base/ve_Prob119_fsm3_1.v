
module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);


typedef enum reg [1:0] {
    STATE_A,
    STATE_B,
    STATE_C,
    STATE_D
} state_t;


state_t currentState, nextState;


always @(posedge clk or posedge areset) begin
    if (areset)
        currentState <= STATE_A;
    else
        currentState <= nextState;
end


always @(*) begin
    case (currentState)
        STATE_A:
            if (in)
                nextState = STATE_B;
            else
                nextState = STATE_A;
        STATE_B:
            if (in)
                nextState = STATE_D;
            else
                nextState = STATE_B;
        STATE_C:
            if (in)
                nextState = STATE_B;
            else
                nextState = STATE_A;
        STATE_D:
            if (in)
                nextState = STATE_D;
            else
                nextState = STATE_B;
        default:
            nextState = STATE_A;
 
    endcase
end


assign out = (currentState == STATE_A || currentState == STATE_C) ? 1'b0 : 1'b1;

endmodule
