
module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [22:0] a_mantissa, b_mantissa;
    reg [47:0] product;
    reg [7:0] sum_exp;
    reg [47:0] shifted_product;
    reg guard, round_bit, sticky;
    reg a_is_nan, b_is_nan;
    reg a_is_inf, b_is_inf;
    reg a_is_zero, b_is_zero;
    reg [22:0] z_mantissa;
    reg round_up;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'b0;
            z <= 32'd0;
        end else begin
            case (counter)
                3'b000: begin
                    
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= a[22:0];
                    b_mantissa <= b[22:0];
                    
                    
                    a_is_nan <= (a[30:23] == 8'hFF) && (|a[22:0]);
                    b_is_nan <= (b[30:23] == 8'hFF) && (|b[22:0]);
                    a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                    b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 0);
                    a_is_zero <= (a[30:23] == 0) && (a[22:0] == 0);
                    b_is_zero <= (b[30:23] == 0) && (b[22:0] == 0);
                    
                    counter <= counter + 1;
                end
                
                3'b001: begin
                    
                    if (a_is_nan || b_is_nan) begin
                        z <= {1'b0, 8'hFF, 23'h1};
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        z <= {1'b0, 8'hFF, 23'h1};
                    end else if (a_is_inf || b_is_inf) begin
                        z <= {(a_sign ^ b_sign), 8'hFF, 23'd0};
                    end else if (a_is_zero || b_is_zero) begin
                        z <= {(a_sign ^ b_sign), 31'd0};
                    end else begin
                        
                        sum_exp <= (a_exponent - 127) + (b_exponent - 127);
                        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    end
                    counter <= counter + 1;
                end
                
                3'b010: begin
                    if (product[47] || product[46]) begin
                        shifted_product <= product >> 1;
                        sum_exp <= sum_exp + 1;
                        {guard, round_bit, sticky} <= {product[45:43]};
                    end else begin
                        shifted_product <= product;
                        {guard, round_bit, sticky} <= {product[44:42]};
                    end
                    z_mantissa <= shifted_product[46:24];
                    round_up <= guard && (round_bit | sticky) || (guard & round_bit);
                    
                    
                    if (round_up) begin
                        z_mantissa <= z_mantissa + 1;
                        if (z_mantissa == 23'h7FFFFF) begin
                            sum_exp <= sum_exp + 1;
                            z_mantissa <= 0;
                        end
                    end
                    
                    if (sum_exp >= 8'hFE) begin
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (sum_exp == 0) begin
                        z <= {z_sign, 31'd0};
                    end else begin
                        z <= {z_sign, sum_exp, z_mantissa};
                    end
                    
                    counter <= 3'b000;
                end
                
                default: begin
                    counter <= 3'b000;
                    z <= 32'd0;
                end
            endcase
        end
    end

endmodule
