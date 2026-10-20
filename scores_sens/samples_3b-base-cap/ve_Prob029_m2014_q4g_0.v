
module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    
    wire out1;
    xor #1 out1 (out1, in1, in2);

    
    xor #1 out (out, out1, in3);

endmodule
