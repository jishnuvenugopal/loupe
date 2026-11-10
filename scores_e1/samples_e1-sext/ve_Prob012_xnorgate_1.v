
module TopModule (
    input  a,
    input  b,
    output out
);

    assign temp = a ^ b;
    assign out = ~temp;

endmodule
