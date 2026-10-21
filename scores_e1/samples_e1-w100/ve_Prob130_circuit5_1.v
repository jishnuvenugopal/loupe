
module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    
    assign q = a & b | a & c | a & d | a & e | b & c | b & d | b & e | c & d | c & e | d & e;

endmodule
