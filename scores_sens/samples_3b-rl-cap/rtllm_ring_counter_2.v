
module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 8'b0000_0001;
 
    end else begin
        
        out <= (out + 1) & 8'b1111_1110;
    end
end




endmodule
