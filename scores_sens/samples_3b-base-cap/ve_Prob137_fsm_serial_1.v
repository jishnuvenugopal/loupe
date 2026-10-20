
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output done
);

    
    typedef enum {IDLE, START, DATA, STOP} state_t;
    state_t current_state, next_state;

    
    reg [7:0] data_buffer;
    reg [7:0] received_data;
    reg [3:0] bit_counter;
    reg [1:0] stop_bit_counter;

    
    reg done_signal;

    
    initial begin
        current_state = IDLE;
        done_signal = 0;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done_signal <= 0;
        end else begin
            current_state <= next_state;

            
            case (current_state)
                IDLE: begin
                    if (in == 1'b0) begin
                        next_state = START;
                        bit_counter <= 0;
                        stop_bit_counter <= 0;
                    end else begin
                        next_state = IDLE;
                    end
                end
                START: begin
                    if (in == 1'b1) begin
                        next_state = DATA;
                        bit_counter <= 0;
                        stop_bit_counter <= 0;
                    end else begin
                        next_state = START;
                    end
                end
                DATA: begin
                    if (bit_counter < 8) begin
                        data_buffer[bit_counter] <= in;
                        bit_counter <= bit_counter + 1;
                        next_state = DATA;
                    end else begin
                        next_state = STOP;
                    end
                end
                STOP: begin
                    if (in == 1'b1) begin
                        stop_bit_counter <= stop_bit_counter + 1;
                        if (stop_bit_counter == 2) begin
                            received_data <= data_buffer;
                            done_signal <= 1;
                            next_state = IDLE;
                        end else begin
                            next_state = STOP;
                        end
                    end else begin
                        next_state = START;
                    end
                end
            endcase
        end
    end

    
    assign done = done_signal;

endmodule
