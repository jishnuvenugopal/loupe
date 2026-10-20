
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

    
    typedef enum {IDLE, WALK_LEFT, WALK_RIGHT, FALLING, DIGGING} state_t;
    state_t current_state, next_state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(current_state, bump_left, bump_right, ground, dig) begin
        case (current_state)
            IDLE: begin
                if (ground) begin
                    if (dig) begin
                        next_state <= DIGGING;
                    end else if (bump_left) begin
                        next_state <= WALK_RIGHT;
                    end else if (bump_right) begin
                        next_state <= WALK_LEFT;
                    end else begin
                        next_state <= WALK_LEFT;
                    end
                end else begin
                    next_state <= FALLING;
                end
            end
            WALK_LEFT: begin
                if (ground) begin
                    if (dig) begin
                        next_state <= DIGGING;
                    end else if (bump_right) begin
                        next_state <= WALK_RIGHT;
                    end else begin
                        next_state <= WALK_LEFT;
                    end
                end else begin
                    next_state <= FALLING;
                end
            end
            WALK_RIGHT: begin
                if (ground) begin
                    if (dig) begin
                        next_state <= DIGGING;
                    end else if (bump_left) begin
                        next_state <= WALK_LEFT;
                    end else begin
                        next_state <= WALK_RIGHT;
                    end
                end else begin
                    next_state <= FALLING;
                end
            end
            FALLING: begin
                if (ground) begin
                    next_state <= WALK_LEFT;
                end else begin
                    next_state <= FALLING;
                end
            end
            DIGGING: begin
                if (ground) begin
                    if (dig) begin
                        next_state <= DIGGING;
                    end else begin
                        next_state <= WALK_LEFT;
                    end
                end else begin
                    next_state <= FALLING;
                end
            end
        endcase
    end

    
    always @(current_state) begin
        case (current_state)
            IDLE: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            WALK_LEFT: begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            WALK_RIGHT: begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            FALLING: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                digging <= 1'b0;
            end
            DIGGING: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b1;
            end
        endcase
    end

endmodule
