
module adder_bcd (
    input [3:0] A,  
    input [3:0] B,  
    input Cin,        
    output [3:0] Sum, 
    output Cout       
);

    reg [4:0] sum;
 

    
    assign sum = A + B + Cin;

    
    assign Sum = (sum > 9) ? (sum - 6) : sum;

    
    assign Cout = (sum > 9) ? 1'b1 : 1'b0;

endmodule
