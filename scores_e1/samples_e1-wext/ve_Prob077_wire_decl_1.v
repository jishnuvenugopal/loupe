
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out,
    output reg out_n
);

    
    wire and1_out, and2_out, or_out;

    
    and1_out = a & b;
    and2_out = c & d;

    
    or_out = and1_out | and2_out;

    
    out_n = ~or_out;

endmodule
