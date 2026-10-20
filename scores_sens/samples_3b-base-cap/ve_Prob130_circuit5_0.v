
module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    
    assign q = (b == 4'h0 && c == 4'h0 && d == 4'h0 && e == 4'h0) ? a : 4'hf;

endmodule
