
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out,
    output reg out_n
);

    
    reg and1_out;
    reg and2_out;
    reg or_out;

    
    and1_out = a & b;
    and2_out = c & d;

    
    or_out = and1_out | and2_out;

    
    out_n = ~or_out;

endmodule
