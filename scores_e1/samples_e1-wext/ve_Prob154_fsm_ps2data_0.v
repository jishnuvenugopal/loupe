
module TopModule (
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg done,
    output reg [23:0] out_bytes
);

    
    typedef enum {IDLE, MESSAGE_START, MESSAGE_DATA, MESSAGE_END} state_t;
    state_t state = IDLE;

    
    reg [7:0] message_data;
    reg [2:0] message_length;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            message_data <= 8'b0;
            message_length <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= MESSAGE_START;
                        message_data <= in;
                        message_length <= 3'b0;
                    end
                end
                MESSAGE_START: begin
                    if (in[3] == 1) begin
                        state <= MESSAGE_DATA;
                        message_data <= in;
                        message_length <= 3'b0;
                    end
                end
                MESSAGE_DATA: begin
                    if (in[3] == 1) begin
                        state <= MESSAGE_END;
                        out_bytes <= message_data;
                        done <= 1;
                        message_data <= in;
                        message_length <= 3'b0;
                    end else begin
                        message_data <= message_data << 1 | in[0];
                        message_length <= message_length + 1;
                    end
                end
                MESSAGE_END: begin
                    if (in[3] == 1) begin
                        state <= MESSAGE_START;
                        message_data <= in;
                        message_length <= 3'b0;
                    end
                end
            endcase
        end
    end

endmodule
