
module TopModule (
    input  in1,
    input  in2,
    output out
);
    wire and_output;

    
    not #1 in2_inv(in2);

    
    and and_gate(out, in1, in2_inv);

endmodule
