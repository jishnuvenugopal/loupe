
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire out,
    output wire out_n
);

    wire and1, and2, or1;

    
    and1 = a & b;
    and2 = c & d;
    or1 = and1 | and2;

    
    out_n = ~or1;

endmodule
