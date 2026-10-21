
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

    parameter IDLE = 0, WAIT_PATTERN = 1, SHIFT_IN = 2, COUNTING = 3, DONE = 4;

    reg [3:0] state;
    reg pattern_detected;
    reg [3:0] shift_count;
    reg [3:0] done_counter;
    reg done_flag;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            pattern_detected <= 0;
            shift_count <= 0;
            done_counter <= 0;
            done_flag <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data == 4'b1101) begin
                        pattern_detected <= 1;
                        state <= WAIT_PATTERN;
                    end
                end
                WAIT_PATTERN: begin
                    if (data == 4'b1101) begin
                        pattern_detected <= 1;
                        state <= SHIFT_IN;
                    end
                end
                SHIFT_IN: begin
                    if (pattern_detected) begin
                        shift_count <= shift_count + 1;
                        if (shift_count == 4) begin
                            state <= COUNTING;
                        end
                    end
                end
                COUNTING: begin
                    if (done_counting) begin
                        done_counter <= done_counter + 1;
                        if (done_counter == 4) begin
                            state <= DONE;
                        end
                    end
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern_detected <= 0;
                        shift_count <= 0;
                        done_counter <= 0;
                        done_flag <= 0;
                    end
                end
            endcase
            shift_ena <= (state == IDLE) ? 0 : (state == WAIT_PATTERN) ? 0 : (state == SHIFT_IN) ? 1 : 0;
            counting <= (state == IDLE) ? 0 : (state == WAIT_PATTERN) ? 0 : (state == SHIFT_IN) ? 0 : (state == COUNTING) ? 1 : 0;
            done <= (state == IDLE) ? 0 : (state == WAIT_PATTERN) ? 0 : (state == SHIFT_IN) ? 0 : (state == COUNTING) ? 0 : (state == DONE) ? 1 : 0;
        end
    end

endmodule
