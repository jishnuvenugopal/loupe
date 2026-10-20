
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

reg current_state;
reg next_state;

localparam STATE_B = 1;
localparam STATE_A = 0;


always @(posedge clk or posedge areset) begin
    if (areset)
        current_state <= STATE_B;
    else
        current_state <= next_state;
end


always @* begin
    case (current_state)
        STATE_B: begin
            if (in)
                next_state = STATE_B;
            else
                next_state = STATE_A;
        end
        STATE_A: begin
            if (in)
                next_state = STATE_A;
            else
                next_state = STATE_B;
        end
        default: next_state = STATE_B;
    endcase
end


assign out = current_state;

endmodule
