
module TopModule (
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg done
);

    
    typedef enum {IDLE, START, RECEIVING} state_t;
    state_t state;

    
    reg [2:0] byte_count;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 3'b000;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= START;
                        byte_count <= 3'b000;
                    end
                end
                START: begin
                    if (in[3] == 1) begin
                        state <= RECEIVING;
                        byte_count <= 3'b000;
                    end
                end
                RECEIVING: begin
                    byte_count <= byte_count + 1'b1;
                    if (byte_count == 3'b111) begin
                        state <= IDLE;
                        done <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule
