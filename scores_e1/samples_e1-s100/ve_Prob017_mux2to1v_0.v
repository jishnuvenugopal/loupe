
module TopModule (
    input  [9:0] a,  
    input  [9:0] b,  
    input  sel,     
    output [9:0] out  
);

    
    assign out = (sel == 1'b0) ? a : b;

endmodule
