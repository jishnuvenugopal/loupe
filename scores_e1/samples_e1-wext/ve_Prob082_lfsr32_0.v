
module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    reg [31:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 32'h1;
        end else begin
            lfsr[31] <= (lfsr[31] ^ lfsr[22] ^ lfsr[2] ^ lfsr[1]);
            for (int i = 30;
 i >= 0;
 i = i - 1) begin
                lfsr[i] <= lfsr[i + 1];
            end
        end
    end

    assign q = lfsr;

endmodule
