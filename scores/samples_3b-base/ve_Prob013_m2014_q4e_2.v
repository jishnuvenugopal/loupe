
module TopModule (
    input  in1,
    input  in2,
    output out
);

    
    wire or_result;
    or or_gate (
        .a(in1),
        .b(in2),
        .y(or_result)
    );

    
    wire not_result;
    not not_gate (
        .a(or_result),
        .y(not_result)
    );

    
    assign out = not_result;

endmodule
