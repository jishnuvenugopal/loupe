
module TopModule (
    input  [3:0] x,  
    output reg f     
);

    
    assign f = x[0] ^ x[1];

endmodule
