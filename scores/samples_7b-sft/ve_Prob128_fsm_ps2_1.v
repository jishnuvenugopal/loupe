
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    
    parameter IDLE      = 2'b00;
    parameter STATE1    = 2'b01;
    parameter STATE2    = 2'b10;
    parameter STATE_DONE= 2'b11;

    reg [1:0] state, next_state;

    
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    
    always @(*) begin
        case (state)
            IDLE:      next_state = in[3] ? STATE1 : IDLE;
            STATE1:    next_state = STATE2;
            STATE2:    next_state = STATE_DONE;
            STATE_DONE: next_state = IDLE;
            default:   next_state = IDLE;
        endcase
    end

    
    always @(posedge clk) begin
        if (reset)
            done <= 0;
        else
            done <= (state == STATE_DONE);
    end

endmodule
