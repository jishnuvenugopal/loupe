
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    assign q = a ? d : 1;
endmodule
