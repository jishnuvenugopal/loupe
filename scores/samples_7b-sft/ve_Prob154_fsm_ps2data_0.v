
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);


localparam IDLE = 2'b00;
localparam S1   = 2'b01;
localparam S2   = 2'b10;
localparam DONE = 2'b11;

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    byte1 <= in;
                    state <= S1;
                end
            end
            S1: begin
                byte2 <= in;
                state <= S2;
            end
            S2: begin
                byte3 <= in;
                state <= DONE;
            end
            DONE: begin
                state <= IDLE;
            end
        endcase
    end
end

assign done = (state == DONE);
assign out_bytes = {byte1, byte2, byte3};

endmodule
