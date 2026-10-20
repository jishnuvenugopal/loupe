
module TopModule (
    input  [7:0] a,    
    input  [7:0] b,    
    output [7:0] s,    
    output       overflow  
);

    
    wire [8:0] sum;
    
    wire [8:0] carry;
  

    
    
    assign sum = a + b + 1;
  

    
    assign s = sum[7:0];
    assign carry = sum[8];

    
    
    assign overflow = carry ^ carry[8];

endmodule
