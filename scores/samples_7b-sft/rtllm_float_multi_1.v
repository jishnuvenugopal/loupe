
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
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [47:0] product;
    reg guard_bit, round_bit, sticky;
    reg signed [8:0] a_actual, b_actual;
    reg signed [8:0] exponent_sum;
    reg signed [8:0] biased_exponent;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'b0;
            z <= 32'b0;
            a_sign <= 0;
            b_sign <= 0;
            z_sign <= 0;
            a_exponent <= 0;
            b_exponent <= 0;
            z_exponent <= 0;
            a_mantissa <= 0;
            b_mantissa <= 0;
            z_mantissa <= 0;
            product <= 0;
            guard_bit <= 0;
            round_bit <= 0;
            sticky <= 0;
            a_actual <= 0;
            b_actual <= 0;
            exponent_sum <= 0;
            biased_exponent <= 0;
        end else begin
            case (counter)
                3'b000: begin
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                    z_sign <= a[31] ^ b[31];
                    if ((a[30:23] == 8'hff && a[22:0] != 0) || (b[30:23] == 8'hff && b[22:0] != 0)) begin
                        z <= 32'h7fc00000;
                        counter <= 3'b000;
                    end else if ((a[30:23] == 8'hff) || (b[30:23] == 8'hff)) begin
                        z <= {z_sign, 8'hff, 23'd0};
                        counter <= 3'b000;
                    end else if ((a[30:23] == 0 && a[22:0] == 0) || (b[30:23] == 0 && b[22:0] == 0)) begin
                        z <= {z_sign, 31'd0};
                        counter <= 3'b000;
                    end else begin
                        a_actual <= (a[30:23] == 0) ? -9'sd126 : ({1'b0, a[30:23]} - 9'sd127);
                        b_actual <= (b[30:23] == 0) ? -9'sd126 : ({1'b0, b[30:23]} - 9'sd127);
                        counter <= counter + 1;
                    end
                end
                3'b001: begin
                    product <= a_mantissa * b_mantissa;
                    counter <= counter + 1;
                end
                3'b010: begin
                    if (product[47]) begin
                        z_mantissa <= product[46:23];
                        exponent_sum <= a_actual + b_actual + 1;
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky <= |product[20:0];
                    end else begin
                        z_mantissa <= product[47:24];
                        exponent_sum <= a_actual + b_actual;
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky <= |product[21:0];
                    end
                    counter <= counter + 1;
                end
                3'b011: begin
                    if (guard_bit) begin
                        if (round_bit || sticky) begin
                            if (z_mantissa == 24'hffffff) begin
                                z_mantissa <= 0;
                                exponent_sum <= exponent_sum + 1;
                            end else begin
                                z_mantissa <= z_mantissa + 1;
                            end
                        end else begin
                            if (z_mantissa[0]) begin
                                z_mantissa <= z_mantissa + 1;
                            end
                        end
                    end
                    biased_exponent <= exponent_sum + 9'sd127;
                    counter <= counter + 1;
                end
                3'b100: begin
                    if (biased_exponent >= 255) begin
                        z <= {z_sign, 8'hff, 23'd0};
                    end else if (biased_exponent <= 0) begin
                        z <= {z_sign, 31'd0};
                    end else begin
                        z <= {z_sign, biased_exponent[7:0], z_mantissa[22:0]};
                    end
                    counter <= 3'b000;
                end
                default: counter <= 3'b000;
            endcase
        end
    end

endmodule
