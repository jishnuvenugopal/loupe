
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    
    typedef enum {IDLE, START, DATA, END} state_t;
    state_t state = IDLE;

    
    reg [7:0] message;
    reg [2:0] message_length;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            message <= 8'b0;
            message_length <= 3'b0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= START;
                        message_length <= 3'b0;
                        message <= in;
                    end
                end
                START: begin
                    if (in[2] == 1) begin
                        state <= DATA;
                        message_length <= 3'b0;
                        message <= in;
                    end
                end
                DATA: begin
                    if (in[3] == 1) begin
                        state <= END;
                        message_length <= 3'b0;
                        message <= in;
                        done <= 1;
                    end
                end
                END: begin
                    
                end
            endcase
        end
    end

endmodule
