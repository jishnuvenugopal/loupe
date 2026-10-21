
module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    
    reg [4:0] lfsr_state = 5'b11111;
 
    localparam TAP_5 = 5'b10000;
    localparam TAP_3 = 5'b01000;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_state <= 5'b11111;
 
        end else begin
            lfsr_state <= {lfsr_state[4], lfsr_state[3] ^ lfsr_state[5], lfsr_state[2] ^ lfsr_state[4], lfsr_state[1] ^ lfsr_state[3], lfsr_state[0] ^ lfsr_state[2]};
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 5'b1;
 
        end else begin
            q <= lfsr_state;
 
        end
    end

endmodule
