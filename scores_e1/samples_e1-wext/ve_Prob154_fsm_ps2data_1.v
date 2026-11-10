
module TopModule (
    input wire clk,
    input wire rst,
    input wire [7:0] in,
    output reg done,
    output reg [23:0] out_bytes
);

    
    typedef enum {IDLE, SEARCHING, RECEIVING} state_t;
    state_t current_state = IDLE;

    
    reg [7:0] message_buffer;
    reg [2:0] message_length;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
            message_buffer <= 8'b0;
            message_length <= 3'b0;
            done <= 0;
            out_bytes <= 24'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (in[3] == 1) begin
                        current_state <= SEARCHING;
                        message_buffer <= in;
                        message_length <= 3'b0;
                    end
                end
                SEARCHING: begin
                    if (in[3] == 1) begin
                        message_buffer <= message_buffer << 8 | in;
                        message_length <= message_length + 1;
                    end else if (message_length == 3) begin
                        current_state <= RECEIVING;
                        out_bytes <= message_buffer;
                        done <= 1;
                    end
                end
                RECEIVING: begin
                    
                end
            endcase
        end
    end

endmodule
