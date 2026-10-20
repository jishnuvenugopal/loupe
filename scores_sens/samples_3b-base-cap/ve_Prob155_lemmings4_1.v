
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

    
    typedef enum {WALK_LEFT, WALK_RIGHT, FALL, DIGGING, SPLATTER} state_t;
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
                end else if (ground && !digging) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (ground && !digging) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALL: begin
                if (ground) begin
                    next_state = WALK_LEFT;
                end else if (digging) begin
                    next_state = DIGGING;
                end else begin
                    next_state = FALL;
                end
            end
            DIGGING: begin
                if (ground) begin
                    next_state = WALK_LEFT;
                end else if (digging) begin
                    next_state = DIGGING;
                end else begin
                    next_state = FALL;
                end
            end
            SPLATTER: begin
                next_state = SPLATTER;
            end
        endcase
    end

    
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
            WALK_RIGHT: begin
                walk_left <= 0;
                walk_right <= 1;
                aaah <= 0;
                digging <= 0;
            end
            FALL: begin
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 1;
                digging <= 0;
            end
            DIGGING: begin
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 1;
            end
            SPLATTER: begin
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end

endmodule
