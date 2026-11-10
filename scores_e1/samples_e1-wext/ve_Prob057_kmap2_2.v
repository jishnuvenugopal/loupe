
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out
);

    
    assign out = a & b | a & c | a & d | b & c | b & d | c & d;

endmodule
