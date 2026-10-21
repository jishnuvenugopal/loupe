
module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input reg ack
);

    
    typedef enum {SEARCH, COUNT, NOTIFY} state_t;
    state_t state;

    
    reg [9:0] counter;

    
    reg is_counting;

    
    reg start_detected;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= SEARCH;
            counter <= 0;
            is_counting <= 0;
            start_detected <= 0;
        end else begin
            case (state)
                SEARCH: begin
                    if (data == 3'b1101) begin
                        start_detected <= 1;
                        state <= COUNT;
                        counter <= 0;
                    end
                end
                COUNT: begin
                    if (counter == (data[3:0] + 1) * 1000) begin
                        state <= NOTIFY;
                        is_counting <= 0;
                        done <= 1;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                NOTIFY: begin
                    if (ack == 1) begin
                        state <= SEARCH;
                        counter <= 0;
                        is_counting <= 0;
                        start_detected <= 0;
                        done <= 0;
                    end
                end
                default: begin
                    state <= SEARCH;
                    counter <= 0;
                    is_counting <= 0;
                    start_detected <= 0;
                    done <= 0;
                end
            endcase
        end
    end

    
    assign count = counter[3:0];
    assign counting = is_counting;
    assign done = done;

endmodule
