
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [2:0] state, next_state;

    parameter IDLE  = 3'b000,
              FIRST = 3'b001,
              SECOND = 3'b010,
              THIRD = 3'b011,
              DONE_STATE = 3'b100;

    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE:   next_state = (in[3]) ? FIRST : IDLE;
            FIRST:  next_state = SECOND;
            SECOND: next_state = THIRD;
            THIRD:  next_state = DONE_STATE;
            DONE_STATE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            done <= 1'b0;
        else
            done <= (state == DONE_STATE);
    end

endmodule
