
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;


parameter IDLE = 2'b00;
parameter RECEIVE_BYTE1 = 2'b01;
parameter RECEIVE_BYTE2 = 2'b10;
parameter RECEIVE_BYTE3 = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    state <= RECEIVE_BYTE1;
                    out_bytes[23:16] <= in;
                end else begin
                    state <= IDLE;
                end
                done <= 1'b0;
            end

            RECEIVE_BYTE1: begin
                state <= RECEIVE_BYTE2;
                out_bytes[15:8] <= in;
            end

            RECEIVE_BYTE2: begin
                state <= RECEIVE_BYTE3;
                out_bytes[7:0] <= in;
            end

            RECEIVE_BYTE3: begin
                state <= IDLE;
                done <= 1'b1;
            end

            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule
