
module multi_8bit (
    input [7:0] A, 
    input [7:0] B, 
    output reg [15:0] product 
);

    
    reg [15:0] temp_product = 16'b0;

    
    for (int i = 0;
 i < 8;
 i++) begin
        
        if (B[i] == 1'b1) begin
            
            temp_product = temp_product + (A << i);
        end
    end

    
    product = temp_product;

endmodule
