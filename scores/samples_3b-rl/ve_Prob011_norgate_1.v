
module TopModule (
    input  a,
    input  b,
    output out
);

    wire nor_out;

    assign nor_out = ~(a | b);
    assign out     = nor_out;

endmodule
