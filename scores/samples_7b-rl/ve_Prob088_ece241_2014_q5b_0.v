
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A;
    reg state_B;
    reg next_state_A;
    reg next_state_B;

    
    assign z = (state_A & x) | (state_B & ~x);

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1;
            state_B <= 0;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    
    always @* begin
        next_state_A = state_A;
        next_state_B = state_B;

        if (state_A) begin 
            if (x) begin
                
                next_state_A = 0;
                next_state_B = 1;
            end
        end
        else begin 
            
            
        end
    end

endmodule
