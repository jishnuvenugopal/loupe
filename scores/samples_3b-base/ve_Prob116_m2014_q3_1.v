
module TopModule (
    input  [3:0] x,  
    output reg f     
);

    
    wire xor_x3_x2 = x[3] ^ x[2];

    
    wire and_x2_x1 = x[2] & x[1];

    
    assign f = xor_x3_x2 ^ and_x2_x1;

endmodule
