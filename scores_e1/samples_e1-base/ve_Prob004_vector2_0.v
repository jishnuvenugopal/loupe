
module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    
    reg [31:0] reversed;

    
    always @(posedge clk) begin
        
        reversed = in;

        
        for (int i = 0;
 i < 4;
 i++) begin
            
            reg [7:0] byte = reversed[7*i:7*i+7];
            
            reversed = reversed << 8;
            
            reversed = reversed | byte;
        end
    end

    
    assign out = reversed;

endmodule
