
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    
    wire sum_ab = a ^ b;

    
    wire sum_cd = c ^ d;

    
    assign out = sum_ab & sum_cd;

endmodule
