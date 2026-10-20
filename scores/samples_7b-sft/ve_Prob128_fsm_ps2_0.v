
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [2:0] state, next_state;

    parameter IDLE  = 3'b000;
    parameter BYTE1 = 3'b001;
    parameter BYTE2 = 3'b010;
    parameter BYTE3 = 3'b011;
    parameter DONE  = 3'b100;

    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE:  next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = DONE;
            DONE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    assign done = (state == DONE);

endmodule
