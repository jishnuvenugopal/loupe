
module TopModule (
    input a,
    input b,
    output out
);

    
    wire and1, and2, or1;

    
    and1 = a & b;
 
    and2 = ~a & ~b;
 

    
    or1 = and1 | and2;
 

    
    assign out = or1;

endmodule
