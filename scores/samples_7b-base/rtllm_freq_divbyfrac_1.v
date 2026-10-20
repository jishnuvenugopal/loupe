
module freq_divbyfrac (
    input wire clk,          
    input wire rst_n,        
    output reg clk_div        
);

reg [2:0] counter;
          
reg clk_div_neg;
            
reg clk_div_pos;
            


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
   
        clk_div_neg <= 0;
   
        clk_div_pos <= 0;
   
    end else begin
        case (counter)
            3'b000: begin       
                clk_div_neg <= 1;
 
                clk_div_pos <= 0;
 
            end
            3'b001: begin       
                clk_div_neg <= 0;
                clk_div_pos <= 0;
            end
            3'b010: begin
                clk_div_neg <= 0;
                clk_div_pos <= 0;
            end
            3'b011: begin
                clk_div_neg <= 0;
                clk_div_pos <= 1;
 
            end
            3'b100: begin
                clk_div_neg <= 0;
                clk_div_pos <= 0;
            end
            3'b101: begin
                clk_div_neg <= 0;
                clk_div_pos <= 0;
            end
            3'b110: begin
                clk_div_neg <= 0;
                clk_div_pos <= 0;
            end
            default: begin
                clk_div_neg <= 0;
                clk_div_pos <= 0;
            end
        endcase
        counter <= counter + 1;
 
        if (counter == 3'b110) begin 
            counter <= 3'b000;
        end
    end
end


assign clk_div = clk_div_neg | clk_div_pos;

endmodule
