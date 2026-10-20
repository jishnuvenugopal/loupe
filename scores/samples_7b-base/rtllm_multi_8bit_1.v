
module multi_8bit (A, B, product);
    input [7:0] A;
    input [7:0] B;
    output reg [15:0] product;

    integer i;

    always @(A or B) begin
        product = 0;
 
        for (i = 0;
 i < 8;
 i = i + 1) begin
            if (B[i] == 1'b1) begin
                product = product + (A << i);
 
            end
        end
    end

endmodule
