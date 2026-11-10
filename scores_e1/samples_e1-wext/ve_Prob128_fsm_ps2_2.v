
module TopModule (
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg done
);

    
    typedef enum {IDLE, START, DATA} state_t;
    state_t state = IDLE;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= START;
                    end
                end
                START: begin
                    if (in[3] == 1) begin
                        state <= DATA;
                    end
                end
                DATA: begin
                    if (in[3] == 1) begin
                        state <= START;
                        done <= 1;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
