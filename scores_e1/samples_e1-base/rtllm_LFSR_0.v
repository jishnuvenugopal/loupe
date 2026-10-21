
module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

    reg [3:0] reg [3:0] state;
    reg [2:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 4'b0000;
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
            if (counter == 3'b001) begin
                state <= state << 1;
                state[3] <= ~state[3] ^ state[2];
            end
            out <= state;
        end
    end

endmodule
