
module TopModule (
    input  in1,
    input  in2,
    output out
);

    
    and #10 and_gate (
        .a(in1),
        .b(in2),
        .y(out)
    );

endmodule
