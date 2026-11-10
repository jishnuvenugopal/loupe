
module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    
    reg [4:0] lfsr_state = 5'b10101;
 

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_state <= 5'b10101;
 
        end else begin
            
            reg [4:0] next_state = lfsr_state;
            next_state[4] = lfsr_state[5] ^ lfsr_state[3];
            next_state[3] = lfsr_state[4];
            next_state[2] = lfsr_state[3];
            next_state[1] = lfsr_state[2];
            next_state[0] = lfsr_state[1];

            
            lfsr_state <= next_state;
        end
    end

    
    assign q = lfsr_state;

endmodule
