
module TopModule(
    input a, b, c, d,
    output q
);
    assign q = ~( ( (~a) & (c | (b & ~c & ~d) )) | (a & ( ~b | (c & d) )) );
endmodule
