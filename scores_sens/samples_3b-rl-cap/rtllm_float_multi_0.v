
module float_multi (
    input        clk,
    input        rst,
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
    reg [31:0] result;

    
    always @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 3'b000;
        else
            counter <= counter + 3'b001;
    end

    
    always @(*) begin
        a_sign = a[31];
        a_exponent = a[30:23];
        a_mantissa = a[22:0];
    end

    
    always @(*) begin
        b_sign = b[31];
        b_exponent = b[30:23];
        b_mantissa = b[22:0];
    end

    
    always @(*) begin
        if (a_exponent == 31'd255 && a_mantissa != 24'd0) begin
            z = a;
 
        end else if (b_exponent == 31'd255 && b_mantissa != 24'd0) begin
            z = b;
 
        end else if (a_exponent == 31'd0 && a_mantissa == 24'd0) begin
            if (b_exponent == 31'd0 && b_mantissa == 24'd0) begin
                z = 32'd0;
 
            end else begin
                z = b;
 
            end
        end else if (b_exponent == 31'd0 && b_mantissa == 24'd0) begin
            z = a;
 
        end else begin
            
        end
    end

    
    always @(*) begin
        
        product = {1'b0, a_mantissa} * {1'b0, b_mantissa};

        
        z_sign = a_sign ^ b_sign;

        
        z_exponent = a_exponent + b_exponent;

        
        if (z_exponent >= 31'd255) begin
            z_exponent = 31'd255;
 
            z_mantissa = 24'd0;
        end else begin
            
            if (product[48] == 1'b1) begin
                product = product << 1;
                z_exponent = z_exponent + 1'b1;
            end
            z_mantissa = product[47:24];
        end
    end

    
    always @(*) begin
        
        reg [48:0] partial_product;
        partial_product = {1'b0, a_mantissa} * {1'b0, b_mantissa};

        
        guard_bit = partial_product[47];
        round_bit = partial_product[46];
        sticky = 0;
        for (int i = 45;
 i >= 23;
 i = i - 1) begin
            if (partial_product[i])
                sticky = 1;
        end

        
        if (sticky) begin
            if (round_bit)
                z_mantissa = z_mantissa + 1'b1;
            else if (round_bit && guard_bit)
                z_mantissa = z_mantissa + 1'b1;
        end
    end

    
    always @(*) begin
        
        result[31] = z_sign;
        result[30:23] = z_exponent;
        result[22:0] = z_mantissa;

        
        if (z_exponent == 31'd255) begin
            result = 32'd87890625;
 
        end else if (z_exponent == 31'd0 && z_mantissa == 24'd0) begin
            result = 32'd0;
 
        end

        
        z = result;
    end

endmodule
