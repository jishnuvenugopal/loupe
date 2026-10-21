
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    
    assign out_sop = (a & b & c & d) | (a & b & c & ~d) | (a & b & ~c & d) | (a & b & ~c & ~d) |
                      (a & ~b & c & d) | (a & ~b & c & ~d) | (a & ~b & ~c & d) | (a & ~b & ~c & ~d) |
                      (b & c & d) | (b & c & ~d) | (b & ~c & d) | (b & ~c & ~d) |
                      (c & d) | (c & ~d) | (d & ~c) | (d & ~d);

    
    assign out_pos = ~(a & b & c & d) & ~(a & b & c & ~d) & ~(a & b & ~c & d) & ~(a & b & ~c & ~d) &
                      ~(a & ~b & c & d) & ~(a & ~b & c & ~d) & ~(a & ~b & ~c & d) & ~(a & ~b & ~c & ~d) &
                      ~(b & c & d) & ~(b & c & ~d) & ~(b & ~c & d) & ~(b & ~c & ~d) &
                      ~(c & d) & ~(c & ~d) & ~(d & ~c) & ~(d & ~d);

endmodule
