
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
    state_t state;

    
    reg [19:0] timer_count;

    
    reg start_flag;

    
    reg end_flag;

    
    reg ack_flag;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            timer_count <= 0;
            start_flag <= 0;
            end_flag <= 0;
            ack_flag <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data == 4'b1101) begin
                        start_flag <= 1;
                        timer_count <= 0;
                        state <= COUNTING;
                    end
                end
                COUNTING: begin
                    if (timer_count < (data[3:0] + 1) * 1000) begin
                        timer_count <= timer_count + 1;
                    end else begin
                        state <= DONE;
                        end_flag <= 1;
                    end
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        timer_count <= 0;
                        start_flag <= 0;
                        end_flag <= 0;
                        ack_flag <= 0;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    count <= 0;
                    counting <= 0;
                    done <= 0;
                end
                COUNTING: begin
                    count <= timer_count[3:0];
                    counting <= 1;
                    done <= 0;
                end
                DONE: begin
                    count <= 0;
                    counting <= 0;
                    done <= 1;
                end
            endcase
        end
    end

endmodule
