
module TopModule (
    input wire in1,
    input wire in2,
    output reg out
);

    
    and2 u_and (
        .a(in1),
        .b(in2),
        .y(out)
    );

endmodule
