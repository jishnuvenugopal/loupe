
module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input reg ack
);

    
    typedef enum {SEARCHING, COUNTING, WAITING} state_t;
    state_t state;

    
    reg [10:0] counter;

    
    reg counting_flag;

    
    reg start_detected;

    
    reg [3:0] next_data;

    
    reg reset_signal;

    
    assign count = counting_flag ? counter : 4'b0000;
    assign counting = counting_flag;
    assign done = counting_flag && !start_detected;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state = SEARCHING;
            counter = 11'b0000000000;
            counting_flag = 0;
            start_detected = 0;
            next_data = 4'b0000;
            reset_signal = 1'b1;
        end else begin
            case (state)
                SEARCHING: begin
                    if (data == 4'b1101) begin
                        start_detected = 1'b1;
                        next_data = data;
                    end else begin
                        next_data = data;
                    end
                end
                COUNTING: begin
                    counter = counter + 1;
                    if (counter == 1000) begin
                        counting_flag = 0;
                        start_detected = 0;
                        next_data = 4'b0000;
                    end
                end
                WAITING: begin
                    if (ack == 1'b1) begin
                        state = SEARCHING;
                        counter = 11'b0000000000;
                        counting_flag = 0;
                        start_detected = 0;
                        next_data = 4'b0000;
                        reset_signal = 1'b1;
                    end
                end
            endcase
        end
    end

endmodule
