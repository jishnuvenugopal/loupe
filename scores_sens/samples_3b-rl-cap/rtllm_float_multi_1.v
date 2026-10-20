
module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    
    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [9:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;
    reg [31:0] z_reg;

    
    assign a_sign = a[31];
    assign b_sign = b[31];
    assign a_exponent = a[30:23];
    assign b_exponent = b[30:23];
    assign a_mantissa = a[22:0];
    assign b_mantissa = b[22:0];
    assign z_sign = a_sign ^ b_sign;

    
    reg a_is_nan, b_is_nan, a_is_inf, b_is_inf, a_is_zero, b_is_zero;
    assign a_is_nan = (a_exponent == 31'd255) && (a_mantissa != 23'd0);
    assign b_is_nan = (b_exponent == 31'd255) && (b_mantissa != 23'd0);
    assign a_is_inf = (a_exponent == 31'd255) && (a_mantissa == 23'd0);
    assign b_is_inf = (b_exponent == 31'd255) && (b_mantissa == 23'd0);
    assign a_is_zero = (a_exponent == 31'd0) && (a_mantissa == 23'd0);
    assign b_is_zero = (b_exponent == 31'd0) && (b_mantissa == 23'd0);

    
    reg [49:0] product_reg;
    always @(*) begin
        if (a_is_nan || b_is_nan)
            product_reg = 50'dNaN;
        else if (a_is_inf || b_is_inf)
            product_reg = (a_sign ^ b_sign) ? 50'd-Inf : 50'dInf;
        else if (a_is_zero || b_is_zero)
            product_reg = 50'd0;
        else begin
            product_reg = {1'b0, a_mantissa} * {1'b0, b_mantissa};
        end
    end

    
    reg [49:0] rounded_product;
    always @(*) begin
        
        guard_bit = product_reg[48];
        round_bit = product_reg[47];
        sticky = product_reg[46:0] != 23'd0;

        
        if (product_reg[49]) begin
            
            if (round_bit || (round_bit && sticky))
                rounded_product = product_reg + 50'd2;
            else
                rounded_product = product_reg;
        end else begin
            
            if (round_bit || (round_bit && sticky))
                rounded_product = product_reg + 50'd1;
            else
                rounded_product = product_reg;
        end
    end

    
    reg [49:0] normalized_product;
    reg [9:0] new_exponent;
    always @(*) begin
        if (rounded_product[49]) begin
            
            if (rounded_product[48:0] == 23'd0) begin
                
                normalized_product = 50'dNaN;
                new_exponent = 10'd31;
            end else begin
                
                while (rounded_product[48:0] < 23'd1) begin
                    rounded_product = rounded_product << 1;
                    new_exponent = new_exponent - 1;
                end
                normalized_product = rounded_product;
            end
        end else begin
            
            if (rounded_product[48:0] == 23'd0) begin
                
                normalized_product = 50'dNaN;
                new_exponent = 10'd31;
            end else begin
                
                while (rounded_product[48:0] < 23'd1) begin
                    rounded_product = rounded_product << 1;
                    new_exponent = new_exponent - 1;
                end
                normalized_product = rounded_product;
            end
        end
    end

    
    always @(*) begin
        if (normalized_product == 50'dNaN)
            z_reg = {31'd0, 23'd255, 9'd31};
        else begin
            z_mantissa = normalized_product[48:25];
            z_exponent = new_exponent + a_exponent + b_exponent - 31'd126;
            z_sign = normalized_product[49];
            z_reg = {z_sign, z_exponent, z_mantissa};
        end
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst)
            z <= 32'd0;
        else
            z <= z_reg;
    end

endmodule
