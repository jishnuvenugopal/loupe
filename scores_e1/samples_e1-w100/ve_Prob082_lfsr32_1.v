
module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    reg [31:0] state = 32'h1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 32'h1;
        end else begin
            if (state[31] == 1'b1) begin
                state[31] <= 1'b0;
                state[22] <= state[22] ^ state[31];
                state[2] <= state[2] ^ state[31];
                state[1] <= state[1] ^ state[31];
            end
            state <= state << 1;
            state[0] <= state[31];
        end
    end

    assign q = state;

endmodule
