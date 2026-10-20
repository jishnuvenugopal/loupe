
module TopModule (
    input  [7:0] in,  
    output [7:0] out  
);

    
    reg [7:0] out_reg = 8'b0;

    
    for (genvar i = 0;
 i < 8;
 i++) begin
        
        out_reg = {out_reg[6:0], 1'b0};
        
        out_reg = out_reg | (in[i] << i);
    end

    
    assign out = out_reg;

endmodule
