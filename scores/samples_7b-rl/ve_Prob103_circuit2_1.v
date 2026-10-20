
module TopModule(input a, b, c, d, output q);
    assign q = (~a & ~d) | (a & (b | c | d));
endmodule
