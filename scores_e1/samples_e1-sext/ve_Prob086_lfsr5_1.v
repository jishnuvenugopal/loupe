
module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    
    reg [4:0] lfsr_state = 5'b10101;
 

    
    localparam TAP1 = 5'b00001;
 
    localparam TAP2 = 5'b00010;
 

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_state <= 5'b10101;
 
        end else begin
            
            reg [4:0] next_state = lfsr_state;
            next_state[TAP1] = lfsr_state[TAP2];
            next_state[TAP2] = lfsr_state[0];
            next_state[0] = lfsr_state[4];
            lfsr_state <= next_state;
        end
    end

    
    assign q = lfsr_state;

endmodule
