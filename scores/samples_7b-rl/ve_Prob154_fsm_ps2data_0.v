
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done,
    output reg [23:0] out_bytes
);
    reg [1:0] state;
    reg [7:0] byte1, byte2;
    
    localparam S_IDLE = 0;
    localparam S_BYTE1 = 1;
    localparam S_BYTE2 = 2;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            done <= 0;
            byte1 <= 0;
            byte2 <= 0;
            out_bytes <= 0;
        end else begin
            done <= 0;
            case (state)
                S_IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        state <= S_BYTE1;
                    end
                end
                S_BYTE1: begin
                    byte2 <= in;
                    state <= S_BYTE2;
                end
                S_BYTE2: begin
                    out_bytes <= {byte1, byte2, in};
                    done <= 1;
                    state <= S_IDLE;
                end
                default: state <= S_IDLE;
            endcase
        end
    end
endmodule
