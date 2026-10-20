
module TopModule (
    input  [7:0] in,  
    output [7:0] out  
);

    
    reg [7:0] reg_out;

    
    always @(*) begin
        
        reg_out = 8'b00000000;

        
        for (int i = 0;
 i < 8;
 i++) begin
            
            reg_out[i] = in[7 - i];
        end
    end

    
    assign out = reg_out;

endmodule
