
module comparator_4bit (
    input [3:0] A, 
    input [3:0] B, 
    output reg A_greater, 
    output reg A_equal,  
    output reg A_less   
);

    
    wire [3:0] diff;
 
    wire [4:0] borrow;
 

    
    
    
    
    
    

    
    assign diff = A - B;
    assign borrow = (A < B) ? 1'b1 : 1'b0;

    
    assign A_greater = borrow;
    assign A_equal = (diff == 0);
    assign A_less = !borrow && (diff != 0);

endmodule
