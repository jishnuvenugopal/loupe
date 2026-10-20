
module TopModule (
    input  [15:0] scancode,  
    output reg left,        
    output reg down,        
    output reg right,       
    output reg up           
);

always @(*) begin
    
    left = 0;
    down = 0;
    right = 0;
    up = 0;

    
    case (scancode[15:8])
        16'h6b: left = 1;
  
        16'h72: down = 1;
  
        16'h74: right = 1;
 
        16'h75: up = 1;
   
        default: ;
         
    endcase
end

endmodule
