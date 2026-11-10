
module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    reg [3:0] reg [3:0] state = 0;
 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
 
        end else begin
            state <= state << 1;
 
            state[0] <= state[3] ^ state[2];
 
            out <= state;
 
        end
    end

endmodule
