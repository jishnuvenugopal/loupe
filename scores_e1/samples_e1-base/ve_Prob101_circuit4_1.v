
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    
    assign q = a & b & c & d;

    
    assign q = #5 q;

endmodule
