
module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    
    reg [31:0] lfsr_state = 32'h1;
 

    
    localparam TAP1 = 32;
    localparam TAP2 = 22;
    localparam TAP3 = 2;
    localparam TAP4 = 1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_state <= 32'h1;
 
            q <= 32'h1;
 
        end else begin
            
            lfsr_state = {lfsr_state[30:0], lfsr_state[31] ^ lfsr_state[TAP1] ^ lfsr_state[TAP2] ^ lfsr_state[TAP3] ^ lfsr_state[TAP4]};
            
            q <= lfsr_state;
        end
    end

endmodule
