
module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    reg [3:0] reg_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_state <= 4'b0000;
        end else begin
            reg_state <= {reg_state[2:0], reg_state[3]};
            out <= {reg_state[3], reg_state[2], reg_state[1], reg_state[0]};
        end
    end

endmodule
