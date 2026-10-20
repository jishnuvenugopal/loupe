
module div_16bit(
    input wire [15:0] A, 
    input wire [7:0] B,  
    output reg [15:0] result, 
    output reg [15:0] odd  
);

    
    reg [15:0] a_reg;
    reg [7:0] b_reg;

    
    always @(*) begin
        a_reg <= A;
        b_reg <= B;
    end

    
    always @(*) begin
        
        reg [7:0] dividend_high;
        dividend_high = a_reg[15:8];

        
        reg [7:0] quotient;
        quotient = (dividend_high >= b_reg) ? 1'b1 : 1'b0;

        
        reg [15:0] remainder;
        remainder = a_reg - (quotient * b_reg);

        
        odd = remainder[15:8] | (dividend_high[7] & ~quotient);

        
        result = {remainder[7:0], quotient};
    end

endmodule
