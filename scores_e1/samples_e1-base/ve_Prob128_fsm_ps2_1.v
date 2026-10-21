
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    
    typedef enum {IDLE, START, DATA} state_t;

    
    state_t state = IDLE;

    
    reg [7:0] message;
    reg [2:0] byte_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            message <= 8'b0;
            byte_count <= 3'b0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= START;
                        byte_count <= 2'b0;
                        message <= in;
                    end
                end
                START: begin
                    if (in[3] == 1) begin
                        state <= DATA;
                        byte_count <= 2'b0;
                        message <= in;
                    end
                end
                DATA: begin
                    if (in[3] == 1) begin
                        byte_count <= byte_count + 1;
                        message[7:0] <= in;
                        if (byte_count == 3) begin
                            state <= IDLE;
                            done <= 1;
                        end
                    end
                end
            endcase
        end
    end

endmodule
