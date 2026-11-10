
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out,
    output reg out_n
);

    wire and1_out, and2_out, or1_out;

    
    assign and1_out = a & b;
    assign and2_out = c & d;

    
    assign or1_out = and1_out | and2_out;

    
    assign out = or1_out;

    
    assign out_n = ~or1_out;

endmodule
