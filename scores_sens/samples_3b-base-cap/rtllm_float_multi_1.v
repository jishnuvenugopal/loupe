
module float_multi (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] z
);

    
    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [9:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            a_mantissa <= 24'b0;
            b_mantissa <= 24'b0;
            z_mantissa <= 24'b0;
            a_exponent <= 10'b0;
            b_exponent <= 10'b0;
            z_exponent <= 10'b0;
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            z_sign <= 1'b0;
            product <= 50'b0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky <= 1'b0;
        end else begin
            counter <= counter + 1'b1;
        end
    end

    
    assign a_mantissa = a[22:0];
    assign a_exponent = a[30:23];
    assign a_sign = a[31];

    
    assign b_mantissa = b[22:0];
    assign b_exponent = b[30:23];
    assign b_sign = b[31];

    
    always @(*) begin
        if (a_mantissa == 24'b0 && a_exponent == 10'b0 && a_sign == 1'b1) begin
            z <= 32'b00000000000000000000000000000000;
 
        end else if (b_mantissa == 24'b0 && b_exponent == 10'b0 && b_sign == 1'b1) begin
            z <= 32'b00000000000000000000000000000000;
 
        end else if (a_exponent == 10'b11111111 && a_mantissa != 24'b0) begin
            z <= 32'b00000000000000000000000000000000;
 
        end else if (b_exponent == 10'b11111111 && b_mantissa != 24'b0) begin
            z <= 32'b00000000000000000000000000000000;
 
        end else if (a_exponent == 10'b0 && a_mantissa == 24'b0) begin
            z <= 32'b00000000000000000000000000000000;
 
        end else if (b_exponent == 10'b0 && b_mantissa == 24'b0) begin
            z <= 32'b00000000000000000000000000000000;
 
        end
    end

    
    always @(*) begin
        if (a_mantissa != 24'b0) begin
            while (a_mantissa[23] == 1'b0) begin
                a_mantissa = a_mantissa << 1;
                a_exponent = a_exponent - 1'b1;
            end
        end
        if (b_mantissa != 24'b0) begin
            while (b_mantissa[23] == 1'b0) begin
                b_mantissa = b_mantissa << 1;
                b_exponent = b_exponent - 1'b1;
            end
        end
    end

    
    always @(*) begin
        product = a_mantissa * b_mantissa;
        z_mantissa = product[48:25];
        z_exponent = a_exponent + b_exponent - 10'b1000000000;
        z_sign = a_sign ^ b_sign;
    end

    
    always @(*) begin
        guard_bit = product[24];
        round_bit = product[23];
        sticky = product[22:0] != 23'b0;
        if (z_mantissa[23] == 1'b1) begin
            if (guard_bit | round_bit | sticky) begin
                z_mantissa = z_mantissa + 1'b1;
                if (z_mantissa[24] == 1'b1) begin
                    z_mantissa = z_mantissa >> 1;
                    z_exponent = z_exponent + 1'b1;
                end
            end
        end
    end

    
    always @(*) begin
        if (z_exponent >= 10'b11111111) begin
            z <= 32'b00000000000000000000000000000000;
 
        end else if (z_exponent <= 10'b0000000000) begin
            z <= 32'b00000000000000000000000000000000;
 
        end else begin
            z[31] = z_sign;
            z[22:0] = z_mantissa;
            z[30:23] = z_exponent + 10'b1000000000;
        end
    end

endmodule
