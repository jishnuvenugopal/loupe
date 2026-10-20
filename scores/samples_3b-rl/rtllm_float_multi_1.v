
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
        if (rst) begin
            counter <= 3'b000;
            a_mantissa <= 24'b0;
            b_mantissa <= 24'b0;
            a_exponent <= 10'b0;
            b_exponent <= 10'b0;
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            z_sign <= 1'b0;
            product <= 49'b0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky <= 1'b0;
            result <= 32'b0;
        end else begin
            case (counter)
                3'b000: begin
                    
                    a_sign = a[31];
                    a_exponent = a[30:23];
                    a_mantissa = a[22:0];
                    
                    b_sign = b[31];
                    b_exponent = b[30:23];
                    b_mantissa = b[22:0];
                    counter <= 3'b001;
                end
                3'b001: begin
                    
                    if (a_exponent == 31'd255 && a_mantissa != 24'd0) begin
                        
                        z_sign = a_sign;
                        z_exponent = 31'd255;
                        z_mantissa = 24'd0;
                    end else if (b_exponent == 31'd255 && b_mantissa != 24'd0) begin
                        
                        z_sign = b_sign;
                        z_exponent = 31'd255;
                        z_mantissa = 24'd0;
                    end else if (a_exponent == 31'd255 && b_exponent == 31'd255 && a_mantissa == 24'd0 && b_mantissa == 24'd0) begin
                        
                        z_sign = 1'b0;
                        z_exponent = 10'd0;
                        z_mantissa = 24'd0;
                    end else begin
                        
                        z_sign = a_sign ^ b_sign;
                        counter <= 3'b010;
                    end
                end
                3'b010: begin
                    
                    product = {1'b0, a_mantissa} * {1'b0, b_mantissa};
                    
                    guard_bit = product[48];
                    round_bit = product[47];
                    sticky = product[46:0] != 24'd0;
                    counter <= 3'b011;
                end
                3'b011: begin
                    
                    if (round_bit || (sticky && (counter == 3'b011))) begin
                        if (product[48])
                            z_mantissa = product[46:0] + 24'd1;
                        else
                            z_mantissa = product[46:0];
                        if (z_mantissa >= 24'd2048) begin
                            z_mantissa = z_mantissa - 24'd2048;
                            z_exponent = z_exponent + 1'b1;
                        end
                    end else begin
                        z_mantissa = product[46:0];
                    end
                    counter <= 3'b100;
                end
                3'b100: begin
                    
                    if (z_exponent == 31'd255) begin
                        
                        z_sign = 1'b0;
                        z_exponent = 31'd255;
                        z_mantissa = 24'd0;
                    end else if (z_mantissa == 24'd0) begin
                        
                        z_sign = 1'b0;
                        z_exponent = 10'd0;
                        z_mantissa = 24'd0;
                    end else begin
                        
                        z_sign = z_sign;
                        z_exponent = z_exponent + a_exponent + b_exponent - 31'd126;
                        z_mantissa = z_mantissa;
                    end
                    counter <= 3'b000;
                end
                default: counter <= 3'b000;
            endcase
        end
    end

    
    always @(*) begin
        if (z_exponent == 31'd255) begin
            
            result = {31'd0, z_sign};
        end else if (z_exponent == 10'd0 && z_mantissa == 24'd0) begin
            
            result = {31'd0, z_sign};
        end else begin
            
            result = {z_sign, z_exponent, z_mantissa[22:0]};
        end
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            z <= result;
        end
    end

endmodule
