
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [7:0] message;
    reg [2:0] state;
    reg [2:0] next_state;
    reg [2:0] byte_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 0;
            message <= 0;
            out_bytes <= 0;
            done <= 0;
        end else begin
            next_state <= state;
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        next_state <= WAIT_FOR_START;
                        byte_count <= 0;
                        message <= in;
                    end
                end
                WAIT_FOR_START: begin
                    if (byte_count == 0) begin
                        next_state <= RECEIVE_MESSAGE;
                        byte_count <= 1;
                        message <= in;
                    end
                end
                RECEIVE_MESSAGE: begin
                    if (byte_count == 2) begin
                        next_state <= IDLE;
                        done <= 1;
                        out_bytes <= message;
                    end
                    byte_count <= byte_count + 1;
                    message <= message << 8 | in;
                end
            endcase
            state <= next_state;
        end
    end

endmodule
