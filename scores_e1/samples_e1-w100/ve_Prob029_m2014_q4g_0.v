
module TopModule (
    input wire in1,
    input wire in2,
    input wire in3,
    output wire out
);

    
    wire xnor1_out;
    wire xnor2_out;

    
    wire xor_out;

    
    XNOR xnor1 (.A(in1), .B(in2), .Y(xnor1_out));
    XNOR xnor2 (.A(xnor1_out), .B(in3), .Y(xnor2_out));

    
    XOR xor (.A(xnor2_out), .B(in3), .Y(xor_out));

    
    assign out = xor_out;

endmodule
