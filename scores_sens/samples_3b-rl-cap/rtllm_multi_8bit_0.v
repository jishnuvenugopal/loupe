
module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    always @(*) begin
        product = 16'b0;
        for (int i = 0;
 i < 8;
 i = i + 1) begin
            if (B[i])
                product = product + A;
            A = A << 1;
        end
    end

endmodule
