
module TopModule (
    input  in1,
    input  in2,
    output out
);

    
    and #1 and_gate (
        .in1(in1),
        .in2(in2),
        .out(out)
    );

endmodule
