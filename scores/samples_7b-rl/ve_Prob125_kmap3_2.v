
module TopModule ( input a, b, c, d, output out );
    assign out = ( (~d & a) ) | (c & d & (a | b));
endmodule
