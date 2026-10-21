
module TopModule (
    input wire in1,
    input wire in2,
    output wire out
);

    
    wire xor_result;

    
    wire not_result;

    
    xor_gate xor_inst (
        .A(in1),
        .B(in2),
        .Y(xor_result)
    );

    
    not_gate not_inst (
        .A(xor_result),
        .Y(not_result)
    );

    
    assign out = not_result;

endmodule
