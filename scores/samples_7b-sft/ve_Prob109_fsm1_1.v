
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);
    reg state_reg;
    reg next_state;

    
    always @(posedge clk, posedge areset) begin
        if (areset)
            state_reg <= 1'b1;
 
        else
            state_reg <= next_state;
    end

    
    always @(*) begin
        case (state_reg)
            1'b1: next_state = in ? 1'b1 : 1'b0;
 
            1'b0: next_state = in ? 1'b0 : 1'b1;
 
            default: next_state = 1'b1;
        endcase
    end

    
    assign out = state_reg;

endmodule
