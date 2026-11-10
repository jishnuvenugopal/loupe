
module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input reg ack
);

    
    typedef enum {IDLE, COUNTING, DONE} state_t;
    state_t state = IDLE;

    
    reg [3:0] delay;
    reg [3:0] remaining_time;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 4'b0000;
            remaining_time <= 4'b0000;
            delay <= 4'b0000;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (data == 4'b1101) begin
                        state <= COUNTING;
                        delay <= 4'b0000;
                        remaining_time <= 4'b0000;
                    end
                end
                COUNTING: begin
                    count <= count + 1;
                    remaining_time <= remaining_time - 1;
                    if (remaining_time == 0) begin
                        state <= DONE;
                        done <= 1'b1;
                    end
                end
                DONE: begin
                    if (ack == 1'b1) begin
                        state <= IDLE;
                        count <= 4'b0000;
                        remaining_time <= 4'b0000;
                        delay <= 4'b0000;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule
