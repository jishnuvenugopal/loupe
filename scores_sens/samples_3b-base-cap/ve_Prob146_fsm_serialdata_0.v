
module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg out_byte,
    output reg done
);

    
    typedef enum {IDLE, START, DATA, STOP} state_t;
    state_t current_state, next_state;

    
    reg [7:0] data;
    reg start_detected;
    reg stop_detected;
    reg [7:0] received_byte;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            start_detected <= 0;
            stop_detected <= 0;
            received_byte <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            current_state <= next_state;

            case (current_state)
                IDLE: begin
                    if (in == 0) begin
                        start_detected <= 1;
                        next_state <= START;
                    end else begin
                        start_detected <= 0;
                        next_state <= IDLE;
                    end
                end

                START: begin
                    if (in == 1) begin
                        next_state <= DATA;
                    end else begin
                        next_state <= START;
                    end
                end

                DATA: begin
                    if (in == 1) begin
                        received_byte <= {received_byte[7:1], in};
                        next_state <= DATA;
                    end else begin
                        next_state <= STOP;
                    end
                end

                STOP: begin
                    if (in == 1) begin
                        stop_detected <= 1;
                        next_state <= IDLE;
                        done <= 1;
                    end else begin
                        stop_detected <= 0;
                        next_state <= STOP;
                    end
                end
            endcase
        end
    end

    
    assign out_byte = done ? received_byte : 8'b0;

endmodule
