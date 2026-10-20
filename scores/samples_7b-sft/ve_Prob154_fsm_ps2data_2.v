
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

parameter IDLE = 2'b00;
parameter COLLECT1 = 2'b01;
parameter COLLECT2 = 2'b10;

reg [1:0] state, next_state;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else begin
        state <= next_state;

        case (state)
            IDLE: if (in[3]) byte1 <= in;
            COLLECT1: byte2 <= in;
            COLLECT2: byte3 <= in;
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE:    next_state = in[3] ? COLLECT1 : IDLE;
        COLLECT1: next_state = COLLECT2;
        COLLECT2: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

assign done = (state == COLLECT2);
assign out_bytes = {byte1, byte2, byte3};

endmodule
