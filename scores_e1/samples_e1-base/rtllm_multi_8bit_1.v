
module multi_8bit (
    input wire [7:0] A,
    input wire [7:0] B,
    output reg [15:0] product
);

always @(posedge clk or negedge rst) begin
    if (rst) begin
        product <= 16'b0;
    end else begin
        reg [7:0] temp_product = 8'b0;
        reg [7:0] temp_multiplier = B;
        reg [7:0] temp multiplicand = A;
        reg [7:0] temp_shifted_product = 8'b0;

        for (int i = 0;
 i < 8;
 i = i + 1) begin
            if (temp_multiplier[i] == 1'b1) begin
                temp_shifted_product = temp_product << 1;
                temp_shifted_product = temp_shifted_product | temp_multiplicand;
            end
            temp_product = temp_shifted_product;
            temp_multiplier = temp_multiplier << 1;
            temp_multiplicand = temp_multiplicand << 1;
        end

        product <= temp_product;
    end
end

endmodule
