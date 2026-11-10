
module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

reg [3:0] reg_state;
reg [1:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        reg_state <= 4'b0000;
        counter <= 2'b00;
    end else begin
        counter <= counter + 1'b1;
        if (counter == 2'b11) begin
            reg_state <= reg_state << 1;
            reg_state[0] <= ~reg_state[3];
        end
        out <= reg_state;
    end
end

endmodule
