
module div_16bit(
    input wire [15:0] A,  
    input wire [7:0] B,   
    output reg [15:0] result,  
    output reg [15:0] odd   
);

    
    reg [15:0] a_reg = A;
  
    reg [7:0] b_reg = B;
   

    
    always @(*) begin
        
        reg [7:0] dividend_high = a_reg[15:8];

        
        if (dividend_high >= b_reg) begin
            
            result[15] = 1'b1;
            
            a_reg = a_reg - b_reg;
        end else begin
            
            result[15] = 1'b0;
            
            a_reg = a_reg << 1;
        end

        
        reg [15:0] remainder = a_reg[15:8];

        
        odd = {remainder, a_reg[7:0]};
    end

endmodule
