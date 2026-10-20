
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;
    reg [7:0] byte1, byte2;

    parameter IDLE = 2'd0, COLLECT_ONE = 2'd1, COLLECT_TWO = 2'd2;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            out_bytes <= 0;
            byte1 <= 0;
            byte2 <= 0;
        end else begin
            done <= 0;
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        state <= COLLECT_ONE;
                    end
                end
                COLLECT_ONE: begin
                    byte2 <= in;
                    state <= COLLECT_TWO;
                end
                COLLECT_TWO: begin
                    out_bytes <= {byte1, byte2, in};
                    done <= 1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
