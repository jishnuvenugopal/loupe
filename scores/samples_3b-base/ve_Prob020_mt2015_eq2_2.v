
module TopModule (
    input  [1:0] A,  
    input  [1:0] B,  
    output reg z     
);

    
    xor #1 (.a(A), .b(B), .y(z));

endmodule
