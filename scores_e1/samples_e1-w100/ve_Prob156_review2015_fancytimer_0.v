
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

    
    reg [11:0] counter;

    
    reg is_counting;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counter <= 12'b0;
            is_counting <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data == 4'b1101) begin
                        state <= COUNTING;
                        counter <= 12'b0;
                        is_counting <= 1;
                    end
                end
                COUNTING: begin
                    counter <= counter + 1'b1;
                    if (counter == (data[3:0] + 1'b1) * 1000) begin
                        state <= DONE;
                        done <= 1;
                    end
                end
                DONE: begin
                    if (ack == 1'b1) begin
                        state <= IDLE;
                        counter <= 12'b0;
                        is_counting <= 0;
                    end
                end
                default: begin
                    state <= IDLE;
                    counter <= 12'b0;
                    is_counting <= 0;
                end
            endcase
        end
    end

    
    assign count = counter[3:0];
    assign counting = is_counting;
    assign done = done;

endmodule
