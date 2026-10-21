
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    
    typedef enum {IDLE, MESSAGE_START, MESSAGE_DATA} state_t;
    state_t current_state = IDLE;

    
    reg [2:0] byte_count;
    reg [2:0] message_length;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            byte_count <= 0;
            message_length <= 0;
            out_bytes <= 0;
            done <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (in[3] == 1) begin
                        byte_count <= 1;
                        message_length <= 0;
                        current_state <= MESSAGE_START;
                    end
                end
                MESSAGE_START: begin
                    if (byte_count == 1) begin
                        byte_count <= 2;
                        message_length <= 1;
                    end else if (byte_count == 2) begin
                        byte_count <= 3;
                        message_length <= 2;
                    end else if (byte_count == 3) begin
                        byte_count <= 0;
                        message_length <= 3;
                        out_bytes <= in;
                        done <= 1;
                    end
                end
                MESSAGE_DATA: begin
                    if (byte_count < 3) begin
                        byte_count <= byte_count + 1;
                        out_bytes[23:16] <= in[7:4];
                        out_bytes[15:8] <= in[3:0];
                    end else if (byte_count == 3) begin
                        byte_count <= 0;
                        message_length <= 3;
                        out_bytes <= in;
                        done <= 1;
                    end
                end
            endcase
        end
    end

endmodule
