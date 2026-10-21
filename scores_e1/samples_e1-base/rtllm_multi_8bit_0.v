
module multi_8bit (
    input wire [7:0] A,  
    input wire [7:0] B,  
    output reg [15:0] product  
);

    reg [7:0] multiplicand = A;
  
    reg [15:0] product_reg = 0;
  

    always @(posedge clk) begin  
        if (reset) begin
            product_reg <= 0;
  
            multiplicand <= A;
  
        end else begin
            if (B[7]) begin  
                product_reg <= product_reg + multiplicand;
  
            end
            multiplicand <= multiplicand << 1;
  
        end
    end

    assign product = product_reg;
  

endmodule
