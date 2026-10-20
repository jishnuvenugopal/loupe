
module TopModule (
    input  clk,
    input  [7:0] in,
    output [7:0] pedge
);

    
    reg [7:0] prev_in;
  
    reg [7:0] pedge_out;
 

    
    always @(posedge clk) begin
        
        prev_in <= in;

        
        if (in != prev_in) begin
            
            pedge_out <= 1'b1;
        end else begin
            
            pedge_out <= 1'b0;
        end
    end

    
    assign pedge = pedge_out;

endmodule
