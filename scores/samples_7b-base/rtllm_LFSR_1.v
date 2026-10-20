
module LFSR (
    input wire clk,          
    input wire rst,          
    output reg [3:0] out    
);
    reg [3:0] shift_reg;
    

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            
            shift_reg <= 4'b0000;
            out <= 4'b0000;
        end else begin
            
            shift_reg <= {shift_reg[2:0], shift_reg[3] ^ shift_reg[2]};
            
            out <= shift_reg;
        end
    end
endmodule
