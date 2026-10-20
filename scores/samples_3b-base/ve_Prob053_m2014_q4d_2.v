
module TopModule (
    input  clk,
    input  in,
    output out
);

    
    reg flipflop_out;

    
    xor xor_gate (
        .a(in),
        .b(flipflop_out),
        .y(flipflop_out)
    );

    
    assign out = flipflop_out;

endmodule
