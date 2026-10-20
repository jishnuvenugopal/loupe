
module TopModule (
    input a, b, c, d,
    output out_sop,
    output out_pos
);
    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);
    assign out_pos = ~out_sop;
endmodule
