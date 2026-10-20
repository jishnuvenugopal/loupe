
module TopModule (
    input  [7:0] in,  
    output [7:0] out   
);

    
    reg [7:0] out_reg = 8'b00000000;

    
    for (genvar i = 0;
 i < 8;
 i = i + 1) begin
        
        out_reg[i] = in[7 - i];
    end

    
    assign out = out_reg;

endmodule
