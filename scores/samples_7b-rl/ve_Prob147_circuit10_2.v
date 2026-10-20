
module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);
    reg state_reg;
    
    always @(posedge clk) begin
        if (a == 0 && b == 0)
            state_reg <= ~state_reg;
    end
    
    assign state = state_reg;
    assign q = state_reg;
endmodule
