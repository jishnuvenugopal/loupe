
module TopModule (
    input [6:0] y,
    input w,
    output Y1,
    output Y3
);
    
    
    
    
    
    wire Y2 = (y[1] & ~w) | (y[5] & ~w);

    
    
    wire Y4 = (y[3] & ~w) | (y[2] & ~w);

    
    
    assign Y1 = y[0] | (y[1] & w) | ...;
 
    assign Y3 = y[3] | (y[2] & ~w) | (y[4] & w);
 

endmodule
