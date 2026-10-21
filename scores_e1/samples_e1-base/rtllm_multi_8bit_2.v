
module multi_8bit (
    input wire [7:0] A,  
    input wire [7:0] B,  
    output reg [15:0] product  
);

    reg [7:0] multiplicand;
  
    reg [15:0] product_reg;
  

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_reg <= 0;
            multiplicand <= 0;
        end else begin
            if (B[7]) begin
                product_reg <= product_reg + A;
                multiplicand <= multiplicand << 1;
            end else begin
                multiplicand <= multiplicand << 1;
            end
        end
    end

    assign product = product_reg;

endmodule
