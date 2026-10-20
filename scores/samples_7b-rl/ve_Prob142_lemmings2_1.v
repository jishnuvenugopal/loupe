
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    
    localparam STATE_NORMAL = 1'b0;
    localparam STATE_FALLING = 1'b1;

    reg state, next_state;
    reg dir_reg, dir_next;
 
    reg prev_dir;
 

    
    assign walk_left = (state == STATE_NORMAL) && !dir_reg;
    assign walk_right = (state == STATE_NORMAL) && dir_reg;
    assign aaah = (state == STATE_FALLING);

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_NORMAL;
            dir_reg <= 0;
            prev_dir <= 0;
        end else begin
            state <= next_state;
            dir_reg <= dir_next;
            
            if (state == STATE_NORMAL && next_state == STATE_FALLING)
                prev_dir <= dir_reg;
        end
    end

    
    always @* begin
        next_state = state;
        dir_next = dir_reg;

        case (state)
            STATE_NORMAL: begin
                if (!ground)
                    next_state = STATE_FALLING;
                else if (bump_left || bump_right)
                    dir_next = ~dir_reg;
            end
            STATE_FALLING: begin
                if (ground) begin
                    next_state = STATE_NORMAL;
                    dir_next = prev_dir;
                end
            end
        endcase
    end

endmodule
