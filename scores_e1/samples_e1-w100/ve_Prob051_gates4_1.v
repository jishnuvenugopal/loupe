
module TopModule (
    input  [3:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    
    and4 u_and (
        .a(in[3]),
        .b(in[2]),
        .c(in[1]),
        .d(in[0]),
        .y(out_and)
    );

    
    or4 u_or (
        .a(in[3]),
        .b(in[2]),
        .c(in[1]),
        .d(in[0]),
        .y(out_or)
    );

    
    xor4 u_xor (
        .a(in[3]),
        .b(in[2]),
        .c(in[1]),
        .d(in[0]),
        .y(out_xor)
    );

endmodule
