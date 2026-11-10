
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    
    typedef enum {IDLE, MESSAGE_START, MESSAGE_DATA} state_t;
    state_t state = IDLE;

    
    reg [7:0] current_byte;
    reg [2:0] bytes_received;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            current_byte <= 8'b0;
            bytes_received <= 3'b0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= MESSAGE_START;
                        current_byte <= in;
                        bytes_received <= 3'b0;
                    end
                end
                MESSAGE_START: begin
                    if (in[3] == 1) begin
                        current_byte <= in;
                        bytes_received <= 3'b0;
                    end else begin
                        current_byte <= current_byte << 1;
                        bytes_received <= bytes_received << 1;
                        bytes_received[0] <= in[3];
                    end
                end
                MESSAGE_DATA: begin
                    if (in[3] == 1) begin
                        current_byte <= current_byte << 1;
                        bytes_received <= bytes_received << 1;
                        bytes_received[0] <= in[3];
                    end else begin
                        current_byte <= current_byte << 1;
                        bytes_received[0] <= in[3];
                        if (bytes_received == 3'b111) begin
                            done <= 1;
                            state <= IDLE;
                        end
                    end
                end
            endcase
        end
    end

endmodule
