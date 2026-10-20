
module TopModule (
    input  [7:0] a,          
    input  [7:0] b,          
    output [7:0] s,          
    output       overflow     
);

    
    wire [8:0] sum;
         
    wire [8:0] carry_in;
    
    wire [8:0] carry_out;
   

    
    
    assign sum = a + b;

    
    
    assign overflow = carry_out ^ carry_in;

    
    assign s = sum[7:0];

endmodule
