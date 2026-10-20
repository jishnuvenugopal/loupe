
module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] A_sub;
    assign A_sub = A - B;

    assign A_less   = A_sub[3];
         
    assign A_equal  = (A_sub == 4'b0000);
 
    assign A_greater = ~(A_equal | A_less);
 

endmodule
