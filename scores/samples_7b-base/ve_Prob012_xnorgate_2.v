
module TopModule (
    input a,
    input b,
    output out
);

assign out = (a == b) ? 1 : 0;

endmodule
