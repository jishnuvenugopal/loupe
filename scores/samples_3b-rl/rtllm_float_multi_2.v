
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

    
    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
        end else begin
            counter <= counter + 3'd1;
        end
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
        if ((a_exponent == 31'd255 && a_mantissa != 23'd0) || (b_exponent == 31'd255 && b_mantissa != 23'd0)) begin
            
            z_sign = 1'b1;
            z_exponent = 31'd255;
            z_mantissa = 23'd0;
        end else if (a_exponent == 31'd255 && b_exponent == 31'd255) begin
            
            z_sign = a_sign ^ b_sign;
            z_exponent = 31'd255;
            z_mantissa = 23'd0;
        end else if (a_exponent == 31'd0 && a_mantissa != 23'd0) begin
            
            z_sign = a_sign;
            z_exponent = 31'd0;
            z_mantissa = 23'd0;
        end else if (b_exponent == 31'd0 && b_mantissa != 23'd0) begin
            
            z_sign = b_sign;
            z_exponent = 31'd0;
            z_mantissa = 23'd0;
        end else begin
            
            z_sign = a_sign ^ b_sign;
            z_exponent = a_exponent + b_exponent - 31'd127;
            z_mantissa = a_mantissa | b_mantissa;
        end
    end

    
    always @(*) begin
        if (z_mantissa[22:0] == 23'd0) begin
            z_mantissa = z_mantissa << 1;
            z_exponent = z_exponent - 1'd1;
        end
    end

    
    always @(*) begin
        product = {1'b0, a_mantissa} * {1'b0, b_mantissa};
        z_mantissa = product[48:25];
        guard_bit = product[24];
        round_bit = product[23];
        sticky = product[22:0] != 23'd0;
    end

    
    always @(*) begin
        if (sticky) begin
            if (round_bit) begin
                if (guard_bit || (z_mantissa[22] && (z_mantissa[21] || z_mantissa[20] || z_mantissa[19] || z_mantissa[18] || z_mantissa[17] || z_mantissa[16] || z_mantissa[15] || z_mantissa[14] || z_mantissa[13] || z_mantissa[12] || z_mantissa[11] || z_mantissa[10] || z_mantissa[9] || z_mantissa[8] || z_mantissa[7] || z_mantissa[6] || z_mantissa[5] || z_mantissa[4] || z_mantissa[3] || z_mantissa[2] || z_mantissa[1] || z_mantissa[0]))) begin
                    z_mantissa = z_mantissa + 23'd1;
                end
            end
        end
    end

    
    always @(*) begin
        if (z_exponent > 8'd254) begin
            z_exponent = 8'd254;
        end else if (z_exponent < 8'd0) begin
            z_exponent = 8'd0;
        end
    end

    
    always @(*) begin
        z = {z_sign, z_exponent, z_mantissa[22:0]};
    end

endmodule
