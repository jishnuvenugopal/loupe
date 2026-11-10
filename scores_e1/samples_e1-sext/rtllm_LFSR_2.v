
module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);


reg [3:0] state = 4'b0000;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 4'b0000;
 
    end else begin
        
        state <= {state[2], state[3], state[0], state[1]};
        out <= state[3] ^ state[2];
 
    end
end

endmodule
