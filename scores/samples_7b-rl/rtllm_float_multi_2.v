
module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [9:0] z_exponent;
    reg [22:0] a_mantissa, b_mantissa;
    reg [23:0] a_mant, b_mant;
    reg [49:0] product;
    reg guard, round, sticky;

    reg [22:0] z_mantissa;
    reg overflow;

    wire a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    reg a_zero_flag, b_zero_flag;
    reg a_inf_flag, b_inf_flag;
    reg a_nan_flag, b_nan_flag;

    assign a_zero = (a_exponent == 0) && (a_mantissa == 0);
    assign b_zero = (b_exponent == 0) && (b_mantissa == 0);
    assign a_nan = (a_exponent == 8'hff) && (a_mantissa != 0);
    assign b_nan = (b_exponent == 8'hff) && (b_mantissa != 0);
    assign a_inf = (a_exponent == 8'hff) && (a_mantissa == 0);
    assign b_inf = (b_exponent == 8'hff) && (b_mantissa == 0);

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'b0;
            a_sign <= 0;
            b_sign <= 0;
            z_sign <= 0;
            a_exponent <= 0;
            b_exponent <= 0;
            z_exponent <= 0;
            a_mant <= 0;
            b_mant <= 0;
            product <= 0;
            z <= 0;
            a_zero_flag <= 0;
            b_zero_flag <= 0;
            a_inf_flag <= 0;
            b_inf_flag <= 0;
            a_nan_flag <= 0;
            b_nan_flag <= 0;
        end else begin
            case (counter)
                3'b000: begin
                    
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= a[22:0];
                    b_mantissa <= b[22:0];
                    a_mant <= {1'b1, a[22:0]};
                    b_mant <= {1'b1, b[22:0]};
                    a_zero_flag <= a_zero;
                    b_zero_flag <= b_zero;
                    a_inf_flag <= a_inf;
                    b_inf_flag <= b_inf;
                    a_nan_flag <= a_nan;
                    b_nan_flag <= b_nan;
                    counter <= 3'b001;
                end
                3'b001: begin
                    
                    if (a_nan_flag || b_nan_flag) begin
                        z <= {a_sign ^ b_sign, 8'hff, 1'b1, 22'b0};
                        counter <= 3'b111;
                    end else if ((a_zero_flag || b_zero_flag) && (a_inf_flag || b_inf_flag)) begin
                        z <= {a_sign ^ b_sign, 8'hff, 1'b1, 22'b0};
                        counter <= 3'b111;
                    end else if (a_zero_flag || b_zero_flag) begin
                        z <= {a_sign ^ b_sign, 8'b0, 23'b0};
                        counter <= 3'b111;
                    end else if (a_inf_flag || b_inf_flag) begin
                        z <= {a_sign ^ b_sign, 8'hff, 23'b0};
                        counter <= 3'b111;
                    end else begin
                        z_exponent <= a_exponent + b_exponent - 127;
                        product <= a_mant * b_mant;
                        counter <= 3'b010;
                    end
                end
                3'b010: begin
                    
                    if (product[49]) begin
                        product <= product >> 1;
                        z_exponent <= z_exponent + 1;
                    end
                    guard <= product[0];
                    round <= product[1];
                    sticky <= |product[2:0];
                    
                    if (guard && (round || sticky) || (guard && !round && (product[2] ^ guard))) begin
                        z_mantissa = product[48:26] + 1;
                        if (z_mantissa == 23'h100000) begin
                            z_mantissa = 0;
                            z_exponent <= z_exponent + 1;
                        end
                    end else begin
                        z_mantissa <= product[48:26];
                    end
                    
                    if (z_exponent >= 11'h400) begin 
                        z <= {a_sign ^ b_sign, 8'hff, 23'h000000};
                    end else if (z_exponent <= 0) begin 
                        z <= {a_sign ^ b_sign, 8'h0, 23'h000000};
                    end else begin
                        z <= {a_sign ^ b_sign, z_exponent[7:0], z_mantissa};
                    end
                    counter <= 3'b111;
                end
                default: begin
                    counter <= 3'b000;
                end
            endcase
        end
    end

endmodule
