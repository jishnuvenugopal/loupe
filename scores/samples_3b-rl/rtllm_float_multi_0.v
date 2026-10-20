
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
    reg [31:0] z32;

    
    assign a_sign = a[31];
    assign a_exponent = a[30:23];
    assign a_mantissa = a[22:0];

    
    assign b_sign = b[31];
    assign b_exponent = b[30:23];
    assign b_mantissa = b[22:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            a_exponent <= 9'd0;
            b_exponent <= 9'd0;
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            z_mantissa <= 24'd0;
            z_exponent <= 9'd0;
            z_sign <= 1'b0;
            product <= 49'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky <= 1'b0;
        end else begin
            case (counter)
                3'd0: begin
                    
                    counter <= 3'd1;
                end
                3'd1: begin
                    
                    a_mantissa <= a[22:0];
                    a_exponent <= a[30:23];
                    a_sign <= a[31];
                    counter <= 3'd2;
                end
                3'd2: begin
                    
                    b_mantissa <= b[22:0];
                    b_exponent <= b[30:23];
                    b_sign <= b[31];
                    counter <= 3'd3;
                end
                3'd3: begin
                    
                    product <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
                    guard_bit <= product[48];
                    round_bit <= product[47];
                    sticky <= product[46];
                    counter <= 3'd4;
                end
                3'd4: begin
                    
                    z_exponent = a_exponent + b_exponent;
                    
                    if (product[48])
                        z_exponent = z_exponent + 1;
                    counter <= 3'd5;
                end
                3'd5: begin
                    
                    if (a_exponent == 255 && a_mantissa != 24'd0) begin
                        
                        z_sign = a_sign;
                        z_exponent = 255;
                        z_mantissa = 24'd0;
                    end else if (b_exponent == 255 && b_mantissa != 24'd0) begin
                        
                        z_sign = b_sign;
                        z_exponent = 255;
                        z_mantissa = 24'd0;
                    end else if (a_exponent == 255 && b_exponent == 255) begin
                        
                        if (a_mantissa == 24'd0 && b_mantissa == 24'd0) begin
                            
                            z_sign = 1'b0;
                            z_exponent = 255;
                            z_mantissa = 24'd0;
                        end else begin
                            
                            z_sign = a_sign ^ b_sign;
                            z_exponent = 255;
                            z_mantissa = 24'd0;
                        end
                    end else if (a_mantissa == 24'd0 && b_mantissa == 24'd0) begin
                        
                        z_sign = 1'b0;
                        z_exponent = 255;
                        z_mantissa = 24'd0;
                    end else begin
                        
                        z_sign = a_sign ^ b_sign;
                        
                        if (product[48])
                            product = product << 1;
                        z_mantissa = product[46:23];
                    end
                    counter <= 3'd6;
                end
                3'd6: begin
                    
                    if (sticky) begin
                        if (round_bit || (round_bit && guard_bit)) begin
                            if (z_mantissa[22])
                                z_mantissa = z_mantissa + 24'd1;
                            z_mantissa[22] = 1'b0;
                        end
                    end
                    
                    if (z_exponent >= 255) begin
                        
                        z_sign = 1'b1;
                        z_exponent = 255;
                        z_mantissa = 24'd0;
                    end else if (z_exponent == 0) begin
                        
                        z_sign = 1'b1;
                        z_exponent = 1'b0;
                        z_mantissa = 24'd0;
                    end else begin
                        
                        z_exponent = z_exponent + 127;
                    end
                    counter <= 3'd7;
                end
                3'd7: begin
                    
                    z32[31] = z_sign;
                    z32[30:23] = z_exponent;
                    z32[22:0] = z_mantissa;
                    z <= z32;
                    counter <= 3'd0;
                end
                default: counter <= 3'd0;
            endcase
        end
    end

endmodule
