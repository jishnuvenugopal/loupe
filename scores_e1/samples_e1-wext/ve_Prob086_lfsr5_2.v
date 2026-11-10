
module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    
    reg [4:0] lfsr_state = 5'b11111;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_state <= 5'b11111;
        end else begin
            
            reg [4:0] xor_result = lfsr_state[4] ^ lfsr_state[5] ^ lfsr_state[3];
            
            lfsr_state <= {xor_result, lfsr_state[4]};
        end
    end

    
    assign q = lfsr_state;

endmodule
