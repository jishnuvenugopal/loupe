
module div_16bit (input [15:0] A, input [7:0] B, output reg [15:0] result, output reg [7:0] odd);

    reg [15:0] a_reg;
    reg [7:0] b_reg;
    reg [15:0] quot;
    reg [7:0] rem;

    always @(*) begin
        a_reg <= A;
        b_reg <= B;
        quot = 0;
        rem = 0;

        for (int i = 15;
 i >= 0;
 i--) begin
            rem = {rem[6:0], a_reg[15]};
 
            a_reg = a_reg << 1;
 
            if (rem >= b_reg) begin
                rem = rem - b_reg;
 
                quot[i] = 1;
 
            end
        end

        result = quot;
        odd = rem;
    end

endmodule
