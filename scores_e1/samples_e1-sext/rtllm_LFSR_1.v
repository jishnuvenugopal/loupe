
module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);


reg [3:0] reg_value = 4'b0001;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        reg_value <= 4'b0001;
 
    end else begin
        
        reg_value = {reg_value[2:0], reg_value[3], reg_value[2] ^ reg_value[3]};
    end
end

assign out = reg_value;
 

endmodule
