
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [2:0] state;
    reg [11:0] byte_count;

    parameter IDLE = 3'b000,
               FIND_START = 3'b001,
               RECEIVE_DATA = 3'b010;

    initial begin
        state = IDLE;
        byte_count = 0;
        done = 0;
        out_bytes = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 0;
            done <= 0;
            out_bytes <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= FIND_START;
                        byte_count <= 1;
                    end
                end
                FIND_START: begin
                    if (byte_count == 3) begin
                        state <= RECEIVE_DATA;
                        byte_count <= 1;
                    end else begin
                        if (in[3] == 1) begin
                            byte_count <= byte_count + 1;
                        end else begin
                            state <= IDLE;
                            byte_count <= 0;
                        end
                    end
                end
                RECEIVE_DATA: begin
                    out_bytes[(byte_count-1)*8 +: 8] <= in;
                    if (byte_count == 3) begin
                        state <= IDLE;
                        done <= 1;
                    end else begin
                        byte_count <= byte_count + 1;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
