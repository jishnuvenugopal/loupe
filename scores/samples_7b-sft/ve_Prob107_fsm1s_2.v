
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);
    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;
    
    reg current_state, next_state;
    
    always @(posedge clk) begin
        if (reset)
            current_state <= STATE_B;
        else
            current_state <= next_state;
    end
    
    always @(*) begin
        case (current_state)
            STATE_B: next_state = in ? STATE_B : STATE_A;
            STATE_A: next_state = in ? STATE_A : STATE_B;
            default: next_state = STATE_B;
        endcase
    end
    
    assign out = (current_state == STATE_B);
endmodule
