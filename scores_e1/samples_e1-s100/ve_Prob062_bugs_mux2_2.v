
module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    assign out = (sel == 0) ? a : (~sel & b);

endmodule
