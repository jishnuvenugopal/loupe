
module multi_8bit (
    input wire [7:0] A,  
    input wire [7:0] B,  
    output reg [15:0] product  
);

    
    reg [15:0] temp_product = 0;

    
    for (genvar i = 0;
 i < 8;
 i = i + 1) begin
        
        if (B[i] == 1) begin
            
            temp_product = temp_product << 1;
            
            temp_product = temp_product | A;
        end
    end

    
    product = temp_product;

endmodule
