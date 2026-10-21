
module TopModule (
    input wire [255:0] in,  
    input wire [7:0] sel,  
    output reg out        
);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            out <= 1'b0;
  
        end else begin
            out <= in[sel];
  
        end
    end

endmodule
