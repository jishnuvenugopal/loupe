
module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    reg [3:0] reg [3:0] state;
    reg [1:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 4'b0000;
            counter <= 2'b00;
        end else begin
            if (counter == 2'b11) begin
                state <= state << 1;
                state[0] <= ~state[3];
                counter <= 2'b00;
            end else begin
                counter <= counter + 1'b1;
            end
        end
        out <= state;
    end

endmodule
