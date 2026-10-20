
module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

    
    typedef enum {WALK_LEFT, WALK_RIGHT, FALLING} state_t;
    state_t current_state, next_state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (ground) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = FALLING;
                end
            end
            WALK_RIGHT: begin
                if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (ground) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end
            FALLING: begin
                if (ground) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = FALLING;
                end
            end
        endcase
    end

    
    assign walk_left = (current_state == WALK_LEFT);
    assign walk_right = (current_state == WALK_RIGHT);
    assign aaah = (current_state == FALLING);

endmodule
