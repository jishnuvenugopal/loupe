
module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);

    
    assign q = (a & b) | (a & c) | (a & d) | (b & c) | (b & d) | (c & d);

endmodule
