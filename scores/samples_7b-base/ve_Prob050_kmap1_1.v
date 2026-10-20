
module TopModule (
    input a,
    input b,
    input c,
    output reg out
);
    assign out = a | (b & c);
endmodule
