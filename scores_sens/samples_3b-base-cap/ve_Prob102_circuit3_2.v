
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    
    wire sum1 = a ^ b;
    wire sum2 = c ^ d;
    wire sum3 = sum1 ^ sum2;

    
    assign q = sum3;

endmodule
