
module multi_8bit (
    input wire [7:0] A,  
    input wire [7:0] B,  
    output reg [15:0] product  
);

    always @(A, B) begin
        product = 0;
  

        for (int i = 0;
 i < 8;
 i++) begin
            if (B[i] == 1) begin
                product = product + A;
  
            end
            A = A << 1;
  
        end
    end

endmodule
