
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

    
    typedef enum {WALK_LEFT, WALK_RIGHT, FALL} state_t;
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

    
    always @(current_state) begin
        case (current_state)
            WALK_LEFT: begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
            end
            WALK_RIGHT: begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                aaah <= 1'b0;
            end
            FALL: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
            end
        endcase
    end

    
    always @(current_state, bump_left, bump_right, ground) begin
        case (current_state)
            WALK_LEFT: begin
                if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (ground) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = FALL;
                end
            end
            WALK_RIGHT: begin
                if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (ground) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = FALL;
                end
            end
            FALL: begin
                if (ground) begin
                    next_state = WALK_LEFT;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = FALL;
                end
            end
        endcase
    end

endmodule
