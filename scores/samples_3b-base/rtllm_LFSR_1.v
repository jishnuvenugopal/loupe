
module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);


initial begin
    out = 4'b0000;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        
        out = 4'b0000;
    end else begin
        
        reg feedback = out[3] ^ out[2];
        feedback = ~feedback;
 

        
        out[3] = out[2];
        out[2] = out[1];
        out[1] = out[0];
        out[0] = feedback;
    end
end

endmodule
