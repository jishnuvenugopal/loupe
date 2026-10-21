
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done,
    output reg [23:0] out_bytes
);

    
    typedef enum {IDLE, MESSAGE_START, MESSAGE_DATA} state_t;
    state_t state = IDLE;

    
    reg [2:0] message_length;
    reg [7:0] current_byte;
    reg [7:0] message_buffer;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            message_length <= 0;
            current_byte <= 0;
            message_buffer <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= MESSAGE_START;
                        current_byte <= in;
                        message_length <= 0;
                    end
                end
                MESSAGE_START: begin
                    if (message_length == 0) begin
                        message_buffer <= current_byte;
                        message_length <= 1;
                    end else if (message_length == 1) begin
                        message_buffer = message_buffer << 8 | current_byte;
                        message_length <= 2;
                    end else if (message_length == 2) begin
                        message_buffer = message_buffer << 8 | current_byte;
                        done <= 1;
                        state <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE;
                    message_length <= 0;
                    current_byte <= 0;
                    message_buffer <= 0;
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_bytes <= 0;
        end else begin
            if (done) begin
                out_bytes <= message_buffer;
            end
        end
    end

endmodule
