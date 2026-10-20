
module TopModule(input a, b, c, d, output out);
    assign out = (~c & ~d & a) | (c & (a | ~b));
endmodule
