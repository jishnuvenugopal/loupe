
module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    
    module out_both (
        input  [99:0] in,
        output [99:0] out
    );
        assign out = (in[99] == 1'b1) && (in[98] == 1'b1);
    endmodule

    
    module out_any (
        input  [99:0] in,
        output [99:0] out
    );
        assign out = (in[0] == 1'b1) || (in[1] == 1'b1);
    endmodule

    
    module out_different (
        input  [99:0] in,
        output [99:0] out
    );
        assign out = (in[99] != in[98]);
    endmodule

    
    out_both out_both_inst (
        .in(in),
        .out(out_both)
    );

    out_any out_any_inst (
        .in(in),
        .out(out_any)
    );

    out_different out_different_inst (
        .in(in),
        .out(out_different)
    );

endmodule
