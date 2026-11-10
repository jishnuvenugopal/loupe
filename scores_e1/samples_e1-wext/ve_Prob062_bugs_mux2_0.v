
module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    assign out = (sel == 1'b1) ? b : a;

endmodule
