
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

    
    assign and1_out = a & b;
    assign and2_out = c & d;

    
    assign or_out = and1_out | and2_out;

    
    assign out = or_out;

    
    assign out_n = ~out;

endmodule
