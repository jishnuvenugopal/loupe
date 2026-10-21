
module TopModule (
    input  [3:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    
    and4 and_gate (
        .A(in[3]),
        .B(in[2]),
        .C(in[1]),
        .D(in[0]),
        .Y(out_and)
    );

    
    or4 or_gate (
        .A(in[3]),
        .B(in[2]),
        .C(in[1]),
        .D(in[0]),
        .Y(out_or)
    );

    
    xor4 xor_gate (
        .A(in[3]),
        .B(in[2]),
        .C(in[1]),
        .D(in[0]),
        .Y(out_xor)
    );

endmodule
