
module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);


reg [3:0] reg = 4'b0001;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        reg <= 4'b0001;
 
    end else begin
        
        reg = {reg[2], reg[3], reg[0], reg[1]};
        out = reg[3];
 
    end
end

endmodule
