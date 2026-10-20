
module TopModule (
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
                end else if (ground == 0) begin
                    next_state = FALLING;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (ground == 0) begin
                    next_state = FALLING;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground == 1) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = FALLING;
                end
            end
        endcase
    end

    
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
            end
            WALK_RIGHT: begin
                walk_left <= 0;
                walk_right <= 1;
                aaah <= 0;
            end
            FALLING: begin
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 1;
            end
        endcase
    end

endmodule
