
module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    
    reg [31:0] lfsr_state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_state <= 32'h1;
        end else begin
            lfsr_state[31] <= lfsr_state[30] ^ lfsr_state[22] ^ lfsr_state[2] ^ lfsr_state[1];
            for (int i = 30;
 i > 0;
 i = i - 1) begin
                lfsr_state[i] <= lfsr_state[i - 1];
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= lfsr_state;
        end
    end

endmodule
