
module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

    
    typedef enum {IDLE, BYTE1, BYTE2, BYTE3, DONE} state_t;
    state_t current_state, next_state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
                    if (in[3]) begin
                        next_state <= BYTE1;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                BYTE1: begin
                    if (in[3]) begin
                        next_state <= BYTE2;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                BYTE2: begin
                    if (in[3]) begin
                        next_state <= BYTE3;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                BYTE3: begin
                    if (in[3]) begin
                        next_state <= DONE;
                        done <= 1;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                DONE: begin
                    if (in[3]) begin
                        next_state <= DONE;
                    end else begin
                        next_state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule
