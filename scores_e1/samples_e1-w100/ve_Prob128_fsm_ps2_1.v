
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    
    typedef enum {IDLE, START, DATA} state_t;
    state_t state;

    
    reg [7:0] current_byte;
    reg [2:0] byte_count;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            current_byte <= 8'b0;
            byte_count <= 3'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= START;
                        current_byte <= in;
                        byte_count <= 3'b0;
                    end
                end
                START: begin
                    if (in[3] == 1) begin
                        state <= DATA;
                        current_byte <= in;
                        byte_count <= 2'b0;
                    end
                end
                DATA: begin
                    if (in[3] == 1) begin
                        byte_count <= byte_count + 1;
                        if (byte_count == 3) begin
                            done <= 1'b1;
                            state <= IDLE;
                        end
                    end else begin
                        current_byte <= current_byte << 1;
                    end
                end
            endcase
        end
    end

endmodule
