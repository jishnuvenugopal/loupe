
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

    
    reg [15:0] counter;

    
    reg is_counting;

    
    reg is_done;

    
    reg [3:0] start_pattern = 4'b1101;

    
    reg [3:0] stop_pattern = 4'b0000;

    
    reg [3:0] ack_pattern = 4'b0001;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counter <= 16'b0;
            is_counting <= 0;
            is_done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data == start_pattern) begin
                        state <= COUNTING;
                        counter <= 0;
                        is_counting <= 1;
                    end
                end
                COUNTING: begin
                    counter <= counter + 1;
                    if (counter == (start_pattern[3] << 12) + (start_pattern[2] << 8) + (start_pattern[1] << 4) + start_pattern[0]) begin
                        state <= DONE;
                        is_done <= 1;
                    end
                end
                DONE: begin
                    if (ack == ack_pattern) begin
                        state <= IDLE;
                        counter <= 16'b0;
                        is_counting <= 0;
                        is_done <= 0;
                    end
                end
            endcase
        end
    end

    assign count = counter[3:0];
    assign counting = is_counting;
    assign done = is_done;

endmodule
