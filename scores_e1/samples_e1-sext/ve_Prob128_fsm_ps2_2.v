
module TopModule (
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg done
);

    
    typedef enum {IDLE, START, DATA} state_t;

    
    state_t state = IDLE;
    reg [2:0] byte_count = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= START;
                        byte_count <= 0;
                    end
                end
                START: begin
                    if (in[3] == 1) begin
                        state <= DATA;
                        byte_count <= 0;
                    end
                end
                DATA: begin
                    if (in[3] == 1) begin
                        byte_count <= byte_count + 1;
                        if (byte_count == 2) begin
                            state <= IDLE;
                            done <= 1;
                        end
                    end else begin
                        byte_count <= 0;
                    end
                end
            endcase
        end
    end

endmodule
