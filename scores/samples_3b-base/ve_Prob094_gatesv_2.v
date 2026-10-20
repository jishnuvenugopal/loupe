
module TopModule (
    input  [3:0] in,        
    output [3:0] out_both,  
    output [3:0] out_any,   
    output [3:0] out_different 
);

    
    reg [3:0] out_both_reg = 4'b0000;
    reg [3:0] out_any_reg = 4'b0000;
    reg [3:0] out_different_reg = 4'b0000;

    
    always @(*) begin
        
        out_both_reg[0] = (in[0] == 1'b1) && (in[1] == 1'b1);
        out_both_reg[1] = (in[1] == 1'b1) && (in[2] == 1'b1);
        out_both_reg[2] = (in[2] == 1'b1) && (in[3] == 1'b1);
        out_both_reg[3] = 1'b0;
 

        
        out_any_reg[0] = (in[0] == 1'b1) || (in[3] == 1'b1);
        out_any_reg[1] = (in[1] == 1'b1) || (in[0] == 1'b1);
        out_any_reg[2] = (in[2] == 1'b1) || (in[1] == 1'b1);
        out_any_reg[3] = (in[3] == 1'b1) || (in[2] == 1'b1);

        
        out_different_reg[0] = (in[0] != in[3]);
        out_different_reg[1] = (in[1] != in[0]);
        out_different_reg[2] = (in[2] != in[1]);
        out_different_reg[3] = (in[3] != in[2]);
    end

    
    assign out_both = out_both_reg;
    assign out_any = out_any_reg;
    assign out_different = out_different_reg;

endmodule
