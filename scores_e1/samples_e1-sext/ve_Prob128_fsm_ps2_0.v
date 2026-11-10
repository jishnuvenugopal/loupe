
module TopModule (
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg done
);

    
    typedef enum {IDLE, RECEIVING, DONE} state_t;

    
    state_t state = IDLE;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= RECEIVING;
                        done <= 0;
                    end
                end
                RECEIVING: begin
                    if (in[3] == 1) begin
                        state <= DONE;
                        done <= 1;
                    end else begin
                        state <= RECEIVING;
                    end
                end
                DONE: begin
                    
                end
            endcase
        end
    end

endmodule
