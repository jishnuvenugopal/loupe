
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    
    typedef enum {IDLE, MESSAGE_START, MESSAGE_DATA, MESSAGE_END} state_t;

    
    state_t state = IDLE;
    reg [7:0] message_data = 0;
    reg [2:0] message_length = 0;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            message_data <= 0;
            message_length <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= MESSAGE_START;
                        message_data <= in;
                        message_length <= 0;
                    end
                end
                MESSAGE_START: begin
                    if (message_length == 0) begin
                        message_data <= in;
                        message_length <= 1;
                    end else if (message_length == 1) begin
                        message_data <= in;
                        message_length <= 2;
                    end else if (message_length == 2) begin
                        message_data <= in;
                        message_length <= 3;
                        state <= MESSAGE_DATA;
                    end
                end
                MESSAGE_DATA: begin
                    if (message_length == 3) begin
                        state <= MESSAGE_END;
                        out_bytes <= message_data;
                        done <= 1;
                    end
                end
                MESSAGE_END: begin
                    state <= IDLE;
                    message_data <= 0;
                    message_length <= 0;
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
                    out_bytes <= message_data;
                    done <= 0;
                end
                MESSAGE_DATA: begin
                    out_bytes <= message_data;
                    done <= 0;
                end
                MESSAGE_END: begin
                    out_bytes <= message_data;
                    done <= 1;
                end
            endcase
        end
    end

endmodule
