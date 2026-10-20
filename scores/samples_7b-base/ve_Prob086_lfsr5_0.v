
module TopModule (
    input wire clk,
    input wire reset,
    output reg [4:0] q
);

reg [4:0] lfsr_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        
        q <= 5'b1;
        lfsr_state <= 5'b00000;
    end else begin
        
        lfsr_state <= {lfsr_state[3:0], lfsr_state[4] ^ lfsr_state[2]};
        
        q <= lfsr_state[0];
    end
end

endmodule
