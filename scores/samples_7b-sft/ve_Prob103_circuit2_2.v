
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    assign q = (a & (c ^ d)) | (b & (c | d)) | (~a & (c | d));
endmodule
