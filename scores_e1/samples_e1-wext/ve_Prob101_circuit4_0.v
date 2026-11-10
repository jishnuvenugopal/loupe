
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg q
);

    assign q = a & b & c & d;

endmodule
