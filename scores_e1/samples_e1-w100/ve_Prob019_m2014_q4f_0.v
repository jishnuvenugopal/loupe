
module TopModule (
    input wire in1,
    input wire in2,
    output reg out
);

    
    and2 and_gate (
        .A(in1),
        .B(in2),
        .Y(out)
    );

endmodule
