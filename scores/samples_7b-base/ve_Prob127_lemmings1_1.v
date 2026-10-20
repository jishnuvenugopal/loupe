
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output wire walk_left,
    output wire walk_right
);


reg walk_left_reg;
reg walk_right_reg;


localparam IDLE = 0;
localparam WALK = 1;


reg [0:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
  
        walk_left_reg <= 1;
        walk_right_reg <= 0;
    end else begin
        case (state)
            IDLE:
                if (bump_left || bump_right) begin
                    state <= WALK;
                    walk_left_reg <= ~walk_left_reg;
                    walk_right_reg <= walk_left_reg;
                end
            WALK:
                if (bump_left || bump_right) begin
                    state <= WALK;
                    walk_left_reg <= ~walk_left_reg;
                    walk_right_reg <= walk_left_reg;
                end
        endcase
    end
end


assign walk_left = walk_left_reg;
assign walk_right = walk_right_reg;

endmodule
