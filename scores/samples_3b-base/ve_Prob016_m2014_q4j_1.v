
module TopModule (
    input  [3:0] x,  
    input  [3:0] y,  
    output [4:0] sum  
);

    
    full_adder fa0 (.a(x[0]), .b(y[0]), .cin(0), .sum(sum[0]), .cout(sum[1]));
    full_adder fa1 (.a(x[1]), .b(y[1]), .cin(sum[1]), .sum(sum[2]), .cout(sum[3]));
    full_adder fa2 (.a(x[2]), .b(y[2]), .cin(sum[3]), .sum(sum[4]), .cout(sum[4]));

endmodule


module full_adder (
    input  a,  
    input  b,  
    input  cin, 
    output sum, 
    output cout  
);

    
    wire s;
 
    wire c;
 

    
    assign s = a ^ b ^ cin;
    assign c = (a & b) | (a & cin) | (b & cin);

    
    assign sum = s;
    assign cout = c;

endmodule
