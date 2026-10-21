
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done,
    output reg [23:0] out_bytes
);

    
    typedef enum {IDLE, MESSAGE_START, MESSAGE_DATA} state_t;
    state_t current_state = IDLE;

    
    reg [2:0] byte_count = 0;
    reg [7:0] message_data = 0;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            byte_count <= 0;
            message_data <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (in[3] == 1) begin
                        current_state <= MESSAGE_START;
                        byte_count <= 0;
                        message_data <= in;
                    end
                end
                MESSAGE_START: begin
                    if (byte_count == 0) begin
                        message_data <= in;
                    end else if (byte_count == 1) begin
                        message_data = message_data << 8 | in;
                    end else if (byte_count == 2) begin
                        message_data = message_data << 8 | in;
                        done <= 1;
                    end
                    byte_count <= byte_count + 1;
                end
                default: begin
                    current_state <= IDLE;
                    byte_count <= 0;
                    message_data <= 0;
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_bytes <= 0;
        end else begin
            if (done) begin
                out_bytes <= message_data;
            end
        end
    end

endmodule
