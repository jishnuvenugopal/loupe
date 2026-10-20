
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    
    parameter S_LEFT = 1'b0;
    parameter S_RIGHT = 1'b1;

    reg state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_LEFT;
 
        end else begin
            
            if (bump_left || bump_right) begin
                state <= ~state;
            end
        end
    end

    
    assign walk_left = (state == S_LEFT);
    assign walk_right = (state == S_RIGHT);

endmodule
