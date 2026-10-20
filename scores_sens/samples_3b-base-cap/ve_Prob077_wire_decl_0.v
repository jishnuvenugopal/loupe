
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    
    wire and1;
    wire and2;
    wire or_gate;
    wire not_gate;

    
    and #(.WIDTH(1)) and1_inst (
        .A(a),
        .B(b),
        .Y(and1)
    );

    and #(.WIDTH(1)) and2_inst (
        .A(c),
        .B(d),
        .Y(and2)
    );

    
    or #(.WIDTH(1)) or_gate_inst (
        .A(and1),
        .B(and2),
        .Y(or_gate)
    );

    
    not #(.WIDTH(1)) not_gate_inst (
        .A(or_gate),
        .Y(not_gate)
    );

    
    assign out = or_gate;
    assign out_n = not_gate;

endmodule
