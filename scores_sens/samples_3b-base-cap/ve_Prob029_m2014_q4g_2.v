
module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    
    assign xor_out = in1 ^ in2;

    
    assign out = xor_out ^ in3;

endmodule
