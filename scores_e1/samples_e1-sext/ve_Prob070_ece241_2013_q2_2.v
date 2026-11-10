
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out_sop,
    output reg out_pos
);

    
    assign out_sop = (a & b & c & d) | (a & b & c & ~d) | (a & b & ~c & d) | (a & ~b & c & d) | (b & c & d & ~a) | (b & c & ~d & a) | (b & ~c & d & a) | (c & d & ~a) | (c & d & ~b) | (d & ~a) | (d & ~b) | (d & ~c);
    assign out_pos = (a & b & c & d) | (a & b & c & ~d) | (a & b & ~c & d) | (a & ~b & c & d) | (b & c & d & ~a) | (b & c & ~d & a) | (b & ~c & d & a) | (c & d & ~a) | (c & d & ~b) | (d & ~a) | (d & ~b) | (d & ~c);

endmodule
