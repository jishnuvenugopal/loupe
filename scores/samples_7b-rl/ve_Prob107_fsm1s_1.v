
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    localparam STATE_B = 1;
    localparam STATE_A = 0;

    reg state;
    reg next_state;

    
    always @(posedge clk) begin
        if (reset)
            state <= STATE_B;
        else
            state <= next_state;
    end

    
    always @* begin
        case (state)
            STATE_B:
                next_state = in ? STATE_B : STATE_A;
            STATE_A:
                next_state = in ? STATE_A : STATE_B;
            default: next_state = STATE_B;
        endcase
    end

    
    assign out = (state == STATE_B) ? 1 : 0;

endmodule
