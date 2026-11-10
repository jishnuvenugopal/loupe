
module TopModule (
    input wire [7:0] in,  
    output reg [2:0] pos   
);

always @(*) begin
    
    pos = 3'b000;

    
    for (int i = 0;
 i < 8;
 i++) begin
        
        if (in[i] == 1'b1) begin
            
            pos = i;
            
            break;
        end
    end
end

endmodule
