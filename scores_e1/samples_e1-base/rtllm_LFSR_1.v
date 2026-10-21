
module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

    
    reg [3:0] reg = 4'b0000;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg <= 4'b0000;
        end else begin
            
            reg = {reg[2:0], reg[3]};
            
            reg = ~reg[3] ^ reg[2];
            
            out <= reg;
        end
    end

endmodule
