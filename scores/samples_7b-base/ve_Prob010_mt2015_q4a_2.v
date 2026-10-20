
module TopModule (
    input x,
    input y,
    output z
);
    reg temp;

    assign temp = x ^ y;
    assign z = temp & x;
endmodule
