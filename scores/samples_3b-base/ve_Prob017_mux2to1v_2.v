
module TopModule (
    input  [99:0] a,  
    input  [99:0] b,  
    input  sel,       
    output [99:0] out  
);

    
    case (sel)
        1'b0: out = a;
  
        1'b1: out = b;
  
    endcase

endmodule
