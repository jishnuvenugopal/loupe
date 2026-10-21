
module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    
    reg [4:0] lfsr_state = 5'b11111;
 
    localparam TAP_5 = 5'b10000;
 
    localparam TAP_3 = 5'b00100;
 

    
    always @(posedge clk) begin
        if (reset) begin
            lfsr_state <= 5'b11111;
 
        end else begin
            lfsr_state[4] <= (lfsr_state[4] ^ lfsr_state[5] ^ lfsr_state[3]);
            lfsr_state[3] <= lfsr_state[4];
            lfsr_state[2] <= lfsr_state[3];
            lfsr_state[1] <= lfsr_state[2];
            lfsr_state[0] <= lfsr_state[1];
        end
    end

    
    assign q = lfsr_state;

endmodule
