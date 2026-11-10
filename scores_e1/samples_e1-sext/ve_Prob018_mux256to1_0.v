
module TopModule (
    input wire [255:0] in,  
    input wire [7:0] sel,   
    output reg out        
);

reg [7:0] currentBit;
  

always @(posedge clk or negedge rst) begin
    if (rst) begin
        currentBit <= 8'b0;
  
        out <= 1'b0;
       
    end else begin
        currentBit <= sel;
  
        out <= in[currentBit];
  
    end
end

endmodule
