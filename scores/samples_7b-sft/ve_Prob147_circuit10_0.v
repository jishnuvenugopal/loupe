
module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);
    reg state_reg;
    
    always @(posedge clk) begin
        state_reg <= next_state;
    end
    
    wire next_state;
    assign next_state = state_reg ? (~a & ~b) : (~a & b);
    assign q = next_state;
    assign state = state_reg;
    
endmodule
