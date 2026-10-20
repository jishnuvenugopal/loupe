
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
            z <= 32'b0;
        end else begin
            case (counter)
                3'b000: begin
                    
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= {a[22:0], 1'b0};
 
                    b_mantissa <= {b[22:0], 1'b0};
 
                    counter <= 3'b001;
                end
                3'b001: begin
                    
                    product <= $signed(a_mantissa) * $signed(b_mantissa);
                    z_exponent <= a_exponent + b_exponent - 127;
                    z_sign <= a_sign ^ b_sign;
                    counter <= 3'b010;
                end
                3'b010: begin
                    
                    guard_bit <= product[23];
                    round_bit <= product[22];
                    sticky <= |product[21:0];
                    z_mantissa <= product[49:24] + guard_bit + round_bit + sticky;
                    z <= {z_sign, z_exponent[9], z_mantissa[22:0]};
                    counter <= 3'b000;
                end
                default: counter <= 3'b000;
            endcase
        end
    end

endmodule
