
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

    
    always @(posedge rst) begin
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
    end

    
    always @(posedge clk) begin
        if (counter == 3'b000) begin
            a_mantissa <= a[22:0];
            b_mantissa <= b[22:0];
            a_exponent <= a[30:23];
            b_exponent <= b[30:23];
            a_sign <= a[31];
            b_sign <= b[31];
            counter <= 3'b001;
        end
    end

    
    always @(posedge clk) begin
        if (counter == 3'b001) begin
            if (a_mantissa == 24'b0 && b_mantissa == 24'b0) begin
                z_mantissa <= 24'b0;
                z_exponent <= 10'b0;
                z_sign <= 1'b0;
                counter <= 3'b000;
            end else if (a_mantissa == 24'b0 || b_mantissa == 24'b0) begin
                z_mantissa <= 24'b0;
                z_exponent <= 10'b0;
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b000;
            end else if (a_exponent == 10'b1111111111 && b_exponent == 10'b1111111111) begin
                z_mantissa <= 24'b0;
                z_exponent <= 10'b1111111111;
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b000;
            end else if (a_exponent == 10'b1111111111 || b_exponent == 10'b1111111111) begin
                z_mantissa <= 24'b0;
                z_exponent <= 10'b1111111111;
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b000;
            end
        end
    end

    
    always @(posedge clk) begin
        if (counter == 3'b001) begin
            if (a_mantissa[23] == 1'b1) begin
                a_mantissa <= a_mantissa << 1;
                a_exponent <= a_exponent + 1;
            end
            if (b_mantissa[23] == 1'b1) begin
                b_mantissa <= b_mantissa << 1;
                b_exponent <= b_exponent + 1;
            end
        end
    end

    
    always @(posedge clk) begin
        if (counter == 3'b001) begin
            product <= a_mantissa * b_mantissa;
            guard_bit <= product[48];
            round_bit <= product[47];
            sticky <= product[46:40];
        end
    end

    
    always @(posedge clk) begin
        if (counter == 3'b001) begin
            if (round_bit == 1'b1 && (sticky == 1'b1 || (sticky == 1'b0 && guard_bit == 1'b1))) begin
                product <= product + 1;
            end
            if (product[49] == 1'b1) begin
                product <= product << 1;
                z_exponent <= z_exponent + 1;
            end
        end
    end

    
    always @(posedge clk) begin
        if (counter == 3'b001) begin
            z_mantissa <= product[48:25];
            z_exponent <= a_exponent + b_exponent + 1;
            z_sign <= a_sign ^ b_sign;
            counter <= 3'b000;
        end
    end

endmodule
