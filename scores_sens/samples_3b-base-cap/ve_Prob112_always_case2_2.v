
module TopModule (
    input  [3:0] in,  
    output [1:0] pos   
);

    
    reg [1:0] pos_reg;

    
    always @(*) begin
        
        pos_reg = 2'b0;

        
        if (in[3]) begin
            pos_reg = 2'b11;
        end else if (in[2]) begin
            pos_reg = 2'b10;
        end else if (in[1]) begin
            pos_reg = 2'b01;
        end else if (in[0]) begin
            pos_reg = 2'b00;
        end
    end

    
    assign pos = pos_reg;

endmodule
