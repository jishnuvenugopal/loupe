
module TopModule (
    input a, b, c, d,
    output q
);
    assign q = (a & (b | c | d)) | (b & ~a) | (c & ~a) | (d & (a | c | b | ~a));
endmodule
