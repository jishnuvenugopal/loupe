
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    
    typedef enum {IDLE, MESSAGE_START, MESSAGE_END} state_t;

    
    state_t state = IDLE;
    reg [7:0] message_start_byte = 0;
    reg [7:0] message_end_byte = 0;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            message_start_byte <= 0;
            message_end_byte <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= MESSAGE_START;
                        message_start_byte <= in;
                    end
                end
                MESSAGE_START: begin
                    if (in[3] == 1) begin
                        state <= MESSAGE_END;
                        message_end_byte <= in;
                    end
                end
                MESSAGE_END: begin
                    if (in[3] == 1) begin
                        state <= IDLE;
                        out_bytes <= message_start_byte << 16 | message_end_byte;
                        done <= 1;
                    end
                end
                default: begin
                    state <= IDLE;
                    message_start_byte <= 0;
                    message_end_byte <= 0;
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_bytes <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    out_bytes <= 0;
                    done <= 0;
                end
                MESSAGE_START: begin
                    out_bytes <= message_start_byte << 16;
                end
                MESSAGE_END: begin
                    out_bytes <= message_end_byte;
                end
                default: begin
                    out_bytes <= 0;
                    done <= 0;
                end
            endcase
        end
    end

endmodule
