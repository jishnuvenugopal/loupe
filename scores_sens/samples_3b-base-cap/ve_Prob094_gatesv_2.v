
module TopModule (
    input  [3:0] in,        
    output [3:0] out_both,  
    output [3:0] out_any,   
    output [3:0] out_different 
);

    
    for (genvar i = 0;
 i < 4;
 i++) begin
        
        out_both[i] = (in[i] == 1'b1) && (in[i+1] == 1'b1);

        
        out_any[i] = (in[i] == 1'b1) || (in[i-1] == 1'b1);

        
        
        out_different[i] = (in[i] != in[(i-1 + 4) % 4]);
    end

endmodule
