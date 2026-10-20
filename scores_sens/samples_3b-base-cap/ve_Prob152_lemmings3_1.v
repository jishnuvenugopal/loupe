
module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    
    typedef enum {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING} state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = WALK_LEFT;
    end

    
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
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    next_state = FALLING;
                end
            end
            DIGGING: begin
                if (ground) begin
                    next_state = WALK_LEFT;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    next_state = FALLING;
                end
            end
        endcase
    end

    
    always @(*) begin
        walk_left = (current_state == WALK_LEFT);
        walk_right = (current_state == WALK_RIGHT);
        aaah = (current_state == FALLING);
        digging = (current_state == DIGGING);
    end

endmodule
