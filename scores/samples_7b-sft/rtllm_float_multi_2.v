
module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;
    reg a_sign, b_sign, z_sign;
    reg [9:0] a_exponent, b_exponent, z_exponent;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;

    
    wire a_is_nan = (a_exponent == 8'hff) && (a_mantissa[22:0] != 0);
    wire a_is_inf = (a_exponent == 8'hff) && (a_mantissa[22:0] == 0);
    wire a_is_zero = (a_exponent == 0) && (a_mantissa[22:0] == 0);
    wire b_is_nan = (b_exponent == 8'hff) && (b_mantissa[22:0] != 0);
    wire b_is_inf = (b_exponent == 8'hff) && (b_mantissa[22:0] == 0);
    wire b_is_zero = (b_exponent == 0) && (b_mantissa[22:0] == 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b0;
            z <= 32'h0;
        end else begin
            case (counter)
                
                3'd0: begin
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (a_exponent == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b_exponent == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                    counter <= 3'd1;
                end
                
                3'd1: begin
                    if (a_is_nan || b_is_nan) begin
                        z <= {a_sign ^ b_sign, 8'hff, 23'h1};
                        counter <= 3'd5;
                    end else if (a_is_inf || b_is_inf) begin
                        if (a_is_zero || b_is_zero) begin
                            z <= {a_sign ^ b_sign, 8'hff, 23'h1};
                        end else begin
                            z <= {a_sign ^ b_sign, 8'hff, 23'h0};
                        end
                        counter <= 3'd5;
                    end else if (a_is_zero || b_is_zero) begin
                        z <= {a_sign ^ b_sign, 8'h0, 23'h0};
                        counter <= 3'd5;
                    end else begin
                        product <= a_mantissa * b_mantissa;
                        z_exponent <= a_exponent + b_exponent - 8'd127;
                        counter <= 3'd2;
                    end
                end
                
                3'd2: begin
                    if (product[47]) begin
                        product <= product >> 1;
                        z_exponent <= z_exponent + 1;
                    end else begin
                        
                        
                    end
                    counter <= 3'd3;
                end
                
                3'd3: begin
                    guard_bit <= product[23];
                    round_bit <= product[22];
                    sticky <= |product[21:0];
                    if ((guard_bit & (round_bit | sticky)) | (guard_bit & ~round_bit & ~sticky & z_mantissa[0])) begin
                        z_mantissa <= z_mantissa + 1;
                        if (z_mantissa == 24'hffffff) begin
                            z_mantissa <= 24'h0;
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    counter <= 3'd4;
                end
                
                3'd4: begin
                    if (z_exponent >= 8'hff) begin
                        z <= {z_sign, 8'hff, 23'h0};
                    end else if (z_exponent == 0) begin
                        z <= {z_sign, 8'h0, 23'h0};
                    end else begin
                        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end
                    counter <= 3'd5;
                end
                default: counter <= 3'd0;
            endcase
        end
    end

endmodule
