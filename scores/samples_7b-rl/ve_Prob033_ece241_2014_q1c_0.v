
module TopModule (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    
    assign s = a + b;
    
    
    wire a_sign, b_sign, sum_sign;
    assign a_sign = a[7];
    assign b_sign = b[7];
    assign sum_sign = s[7];
    
    assign overflow = (a_sign == b_sign) && (sum_sign != a_sign);
endmodule
