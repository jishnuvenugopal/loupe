
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

    
    reg done_flag;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 4'b0000;
            timer_count <= 20'b0;
            start_flag <= 0;
            done_flag <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data == 4'b1101) begin
                        start_flag <= 1;
                        count <= 4'b0000;
                        timer_count <= 20'b0;
                    end
                end
                COUNTING: begin
                    if (timer_count == (data[3:0] + 1) * 1000) begin
                        done_flag <= 1;
                        state <= DONE;
                    end else begin
                        timer_count <= timer_count + 1;
                    end
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        count <= 4'b0000;
                        timer_count <= 20'b0;
                        start_flag <= 0;
                        done_flag <= 0;
                    end
                end
            endcase
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counting <= 0;
        end else begin
            counting <= start_flag;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 0;
        end else begin
            done <= done_flag;
        end
    end

endmodule
