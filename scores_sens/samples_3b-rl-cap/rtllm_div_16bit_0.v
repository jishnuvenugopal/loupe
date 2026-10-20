
module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0] b_reg;

    always @ (A or B) begin
        a_reg <= A;
        b_reg <= B;
    end

    always @ (A or B) begin
        
        reg [7:0] upper_8_bits = a_reg[15:8];
        
        reg [7:0] lower_8_bits = a_reg[7:0];

        
        if (upper_8_bits >= b_reg) begin
            result[15] = 1;
            odd[15:8] = upper_8_bits - b_reg;
        end else begin
            result[15] = 0;
            odd[15:8] = upper_8_bits;
        end

        
        if (lower_8_bits >= b_reg) begin
            result[14] = 1;
            odd[7:0] = lower_8_bits - b_reg;
        end else begin
            result[14] = 0;
            odd[7:0] = lower_8_bits;
        end
    end

endmodule
