
module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg [23:0] a_mantissa, b_mantissa;
    reg [47:0] product;
    reg guard_bit, round_bit, sticky;

    
    reg [7:0] intermediate_exponent;
    reg [47:0] normalized_product;
    reg [22:0] rounded_mantissa;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'b0;
            z <= 32'b0;
            a_sign <= 0;
            b_sign <= 0;
            a_exponent <= 0;
            b_exponent <= 0;
            a_mantissa <= 0;
            b_mantissa <= 0;
            product <= 0;
            guard_bit <= 0;
            round_bit <= 0;
            sticky <= 0;
            intermediate_exponent <= 0;
            normalized_product <= 0;
            rounded_mantissa <= 0;
        end else begin
            case (counter)
                3'b000: begin
                    
                    a_sign <= a[31];
                    a_exponent <= a[30:23];
                    a_mantissa <= {1'b1, a[22:0]};
                    b_sign <= b[31];
                    b_exponent <= b[30:23];
                    b_mantissa <= {1'b1, b[22:0]};

                    
                    if (a_exponent == 8'hff || b_exponent == 8'hff) begin
                        if (a_exponent == 8'hff && b_exponent == 8'hff) begin
                            z <= {a_sign ^ b_sign, 8'hff, 23'h1};
                        end else if (a_exponent == 8'hff || b_exponent == 8'hff) begin
                            z <= {a_sign ^ b_sign, 8'hff, 23'h1};
                        end
                        counter <= 3'b111;
                    end else if (a_exponent == 0 || b_exponent == 0) begin
                        
                        if (a_exponent == 0 && b_exponent == 0) begin
                            z <= {a_sign ^ b_sign, 31'b0};
                        end else if (a_exponent == 0) begin
                            z <= {b_sign ^ a_sign, 31'b0};
                        end else begin
                            z <= {a_sign ^ b_sign, 31'b0};
                        end
                        counter <= 3'b111;
                    end else begin
                        
                        intermediate_exponent <= a_exponent + b_exponent - 8'd127;
                        product <= a_mantissa * b_mantissa;
                        counter <= 3'b001;
                    end
                end

                3'b001: begin
                    
                    if (product[47]) begin
                        normalized_product <= product >> 1;
                        intermediate_exponent <= intermediate_exponent + 1;
                    end else begin
                        normalized_product <= product;
                    end
                    counter <= 3'b010;
                end

                3'b010: begin
                    
                    guard_bit <= normalized_product[23];
                    round_bit <= normalized_product[22];
                    sticky <= |normalized_product[21:0];
                    rounded_mantissa <= normalized_product[46:24] + 
                                       (guard_bit & (round_bit | sticky));
                    counter <= 3'b011;
                end

                3'b011: begin
                    
                    if (rounded_mantissa[22]) begin
                        rounded_mantissa <= rounded_mantissa >> 1;
                        intermediate_exponent <= intermediate_exponent + 1;
                    end
                    if (intermediate_exponent >= 8'hff) begin
                        z <= {a_sign ^ b_sign, 8'hff, 23'b0};
                    end else if (intermediate_exponent == 0) begin
                        z <= {a_sign ^ b_sign, 31'b0};
                    end else begin
                        z <= {a_sign ^ b_sign, intermediate_exponent, rounded_mantissa[21:0]};
                    end
                    counter <= 3'b100;
                end

                3'b111: begin
                    counter <= 3'b000;
                end

                default: counter <= 3'b000;
            endcase
        end
    end

endmodule
