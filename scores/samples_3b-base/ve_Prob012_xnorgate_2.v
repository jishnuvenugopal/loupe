
module TopModule (
    input a,
    input b,
    output out
);

    
    wire and_result;
    and and_gate (
        .a(a),
        .b(b),
        .y(and_result)
    );

    
    not not_gate (
        .a(and_result),
        .y(out)
    );

endmodule
