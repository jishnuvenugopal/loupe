
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state_reg, state_next;

    
    always @(*) begin
        case (state_reg)
            1'b0: 
                state_next = in ? 1'b0 : 1'b1;
            1'b1: 
                state_next = in ? 1'b1 : 1'b0;
            default: state_next = 1'b0;
        endcase
    end

    
    always @(posedge clk) begin
        if (reset)
            state_reg <= 1'b0;
        else
            state_reg <= state_next;
    end

    
    assign out = ~state_reg;

endmodule
