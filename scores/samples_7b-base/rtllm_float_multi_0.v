
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

    
    localparam IDLE = 3'b000;
    localparam PROCESS_INPUT = 3'b001;
    localparam SPECIAL_CASES = 3'b010;
    localparam MULTIPLY = 3'b011;
    localparam ADJUST = 3'b100;

    
    reg [2:0] state;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
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
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (counter == 3'b000) begin
                        counter <= 3'b001;
                    end
                end

                PROCESS_INPUT: begin
                    a_mantissa <= a[22:0];
                    b_mantissa <= b[22:0];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_sign <= a[31];
                    b_sign <= b[31];
                    counter <= 3'b010;
                end

                SPECIAL_CASES: begin
                    
                    
                    
                    counter <= 3'b100;
                end

                MULTIPLY: begin
                    product <= a_mantissa * b_mantissa;
                    guard_bit <= product[50];
                    round_bit <= product[49];
                    sticky <= product[48] | product[47] | product[46] | product[45] | product[44] | product[43] | product[42] | product[41] | product[40];
                    counter <= 3'b101;
                end

                ADJUST: begin
                    z_exponent <= a_exponent + b_exponent - 127;
                    if (z_exponent > 255) begin
                        z_exponent <= 255;
                        z_mantissa <= 24'b0;
                        z_sign <= a_sign ^ b_sign;
                    end else if (z_exponent < 0) begin
                        z_exponent <= 0;
                        z_mantissa <= 24'b0;
                        z_sign <= a_sign ^ b_sign;
                    end else begin
                        if (product[49]) begin
                            z_mantissa <= {product[25], product[48:1], product[0]};
                        end else begin
                            z_mantissa <= {product[25], product[47:2], product[1]};
                        end
                        if (round_bit) begin
                            if (guard_bit || sticky) begin
                                z_mantissa <= z_mantissa + 1;
                            end
                        end
                        if (z_mantissa[24] != z_mantissa[23]) begin
                            z_exponent <= z_exponent + 1;
                            z_mantissa <= z_mantissa >> 1;
                        end
                    end
                    z_sign <= a_sign ^ b_sign;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

    assign z = {z_sign, z_exponent, z_mantissa};

endmodule
