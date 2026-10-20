
module TopModule (
    input  [7:0] in,  
    output [2:0] pos   
);

    
    assign pos = 3'b000;

    
    for (genvar i = 0;
 i < 8;
 i++) begin
        
        if (in[i] == 1'b1) begin
            
            pos = i;
            
            break;
        end
    end

endmodule
