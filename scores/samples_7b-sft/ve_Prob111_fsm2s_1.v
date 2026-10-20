
module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);
    parameter OFF = 1'b0;
    parameter ON = 1'b1;
    
    reg current_state, next_state;
    
    
    always @(posedge clk) begin
        if (reset)
            current_state <= OFF;
        else
            current_state <= next_state;
    end
    
    
    always @(*) begin
        case (current_state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end
    
    
    assign out = current_state;
    
endmodule
