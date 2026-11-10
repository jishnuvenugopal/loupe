
module TopModule (
    input wire clk,
    input wire reset,
    input wire data,
    input wire done_counting,
    input wire ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    
    typedef enum {IDLE, COUNTING, DONE} state_t;
    state_t state;

    
    reg [3:0] counter;

    
    reg start_detected;
    reg done_flag;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counter <= 4'b0000;
            start_detected <= 0;
            done_flag <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data == 4'b1101) begin
                        start_detected <= 1;
                        state <= COUNTING;
                    end
                end
                COUNTING: begin
                    counter <= counter + 1;
                    if (counter == 4'b1111) begin
                        state <= DONE;
                        done_flag <= 1;
                    end
                end
                DONE: begin
                    if (done_counting) begin
                        state <= IDLE;
                        done_flag <= 0;
                    end
                end
            endcase
        end
    end

    
    assign shift_ena = state == COUNTING;
    assign counting = state == COUNTING;
    assign done = state == DONE;

endmodule
