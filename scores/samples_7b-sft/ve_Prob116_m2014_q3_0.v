
module TopModule (
    input [3:0] x,
    output f
);
    
    wire x3 = x[3];
    wire x4 = x[2];
    wire x1 = x[1];
    wire x2 = x[0];
    
    
    assign f = (~x3 & x4 & x1 & x2) | ( (x3 | x4) & ~x1 );
endmodule
