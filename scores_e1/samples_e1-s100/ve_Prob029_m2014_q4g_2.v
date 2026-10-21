
module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    
    wire xnor_out;

    
    wire xor_out;

    
    XNOR xnor (
        .A(in1),
        .B(in2),
        .Y(xnor_out)
    );

    
    XOR xor (
        .A(xnor_out),
        .B(in3),
        .Y(xor_out)
    );

    
    assign out = xor_out;

endmodule
