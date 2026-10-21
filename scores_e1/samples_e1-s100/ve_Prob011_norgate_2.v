
module TopModule (
    input a,
    input b,
    output out
);

    
    wire and_result;

    and_gate and_gate_inst (
        .a(a),
        .b(b),
        .out(and_result)
    );

    
    not_gate not_gate_inst (
        .in(and_result),
        .out(out)
    );

endmodule
