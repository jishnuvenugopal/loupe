
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    
    typedef enum {IDLE, START, DATA} state_t;

    
    state_t state = IDLE;

    
    reg [7:0] data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data <= 8'b0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= START;
                        data <= in;
                    end
                end
                START: begin
                    if (in[3] == 1) begin
                        state <= DATA;
                        data <= in;
                    end
                end
                DATA: begin
                    if (in[3] == 1) begin
                        state <= IDLE;
                        done <= 1;
                    end
                end
            endcase
        end
    end

endmodule
