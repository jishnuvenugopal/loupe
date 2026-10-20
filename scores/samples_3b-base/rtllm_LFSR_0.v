
module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);


always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000;
    end else begin
        
        reg feedback = out[3] ^ out[2];
        
        
        feedback = ~feedback;
        
        
        out <= {feedback, out[3:1]};
    end
end

endmodule
