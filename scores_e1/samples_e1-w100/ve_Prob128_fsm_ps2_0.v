
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    
    typedef enum {IDLE, START, DATA} state_t;
    state_t state;

    
    reg [2:0] byte_count;
    reg [7:0] message;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 0;
            message <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= START;
                        byte_count <= 0;
                        message <= in;
                    end
                end
                START: begin
                    if (in[3] == 1) begin
                        byte_count <= 1;
                        message <= in;
                    end else begin
                        byte_count <= 0;
                        message <= 0;
                    end
                end
                DATA: begin
                    if (in[3] == 1) begin
                        byte_count <= 2;
                        message <= in;
                        state <= IDLE;
                        done <= 1;
                    end else begin
                        byte_count <= 1;
                        message <= in;
                    end
                end
            endcase
        end
    end

endmodule
