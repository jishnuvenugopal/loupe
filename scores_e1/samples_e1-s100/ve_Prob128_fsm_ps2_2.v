
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    
    typedef enum {idle, searching, message_start, message_complete} state_t;
    state_t state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= idle;
            done <= 0;
        end else begin
            case (state)
                idle:
                    if (in[3] == 1) begin
                        state <= searching;
                    end
                searching:
                    if (in[3] == 1) begin
                        state <= message_start;
                    end
                message_start:
                    if (in[3] == 1) begin
                        state <= message_complete;
                        done <= 1;
                    end
                message_complete:
                    done <= 1;
            endcase
        end
    end

endmodule
