
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state_reg;
    localparam WALK_LEFT = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state_reg <= WALK_LEFT;
        end else begin
            if (bump_left || bump_right) begin
                state_reg <= ~state_reg;
            end
        end
    end

    assign walk_left = ~state_reg;
    assign walk_right = state_reg;

endmodule
