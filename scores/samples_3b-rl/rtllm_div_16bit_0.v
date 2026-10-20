
module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0] b_reg;
    reg [15:0] quotient;
    reg [15:0] remainder;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    always @(*) begin
        result = 16'b0;
        odd = 16'b0;
        quotient = 16'b0;
        remainder = 16'b0;

        for (int i = 15;
 i >= 8;
 i = i - 8) begin
            
            reg [7:0] segment = a_reg[i:8];
            
            if (segment >= b_reg) begin
                
                result[i-8] = 1'b1;
                
                remainder = segment - b_reg;
            end else begin
                
                result[i-8] = 1'b0;
                
                remainder = segment;
            end
            
            a_reg = {remainder, a_reg[7:0]};
        end
    end

endmodule
