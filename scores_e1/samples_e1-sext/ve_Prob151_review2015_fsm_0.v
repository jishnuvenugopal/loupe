
module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    
    typedef enum {IDLE, COUNTING, DONE} state_t;

    
    state_t state;

    
    reg [3:0] count;

    
    initial begin
        state = IDLE;
        count = 0;
    end

    
    always @(posedge clk) begin
        if (reset) begin
            state = IDLE;
            count = 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data == 4'b1101) begin
                        state = COUNTING;
                        count = 0;
                    end
                end
                COUNTING: begin
                    count = count + 1;
                    if (count == 4) begin
                        state = DONE;
                    end
                end
                DONE: begin
                    if (done_counting) begin
                        state = IDLE;
                    end
                end
                default: begin
                    state = IDLE;
                end
            endcase
        end
    end

    
    assign shift_ena = state == COUNTING;
    assign counting = state == COUNTING;
    assign done = state == DONE;

endmodule
