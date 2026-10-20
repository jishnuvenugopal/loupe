
module div_16bit (A, B, result, odd);
    input [15:0] A;
    input [7:0] B;
    output [15:0] result;
    output [15:0] odd;

    reg [15:0] a_reg;
    reg [7:0] b_reg;
    reg [15:0] quotient;
    reg [7:0] remainder;

    
    always @ (A, B) begin
        a_reg = A;
        b_reg = B;
    end

    
    reg [15:0] divd;
    reg [7:0] divisor;
    reg [7:0] rem;
    reg [15:0] q;
    integer i;
    always @* begin
        divd = a_reg;
        divisor = b_reg;
        rem = 8'd0;
        q = 16'd0;
        for (i = 15;
 i >= 0;
 i = i - 1) begin
            rem = (rem << 1) | (divd[i] ? 1 : 0);
            if (rem >= divisor) begin
                rem = rem - divisor;
                q[i] = 1;
            end else begin
                q[i] = 0;
            end
        end
        quotient = q;
        remainder = rem;
    end

    assign result = quotient;
    assign odd = {8'b0, remainder};
endmodule
