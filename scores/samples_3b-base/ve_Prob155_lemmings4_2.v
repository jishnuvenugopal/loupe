
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

    
    typedef enum {IDLE, WALK_LEFT, WALK_RIGHT, FALL, DIG} state_t;
    state_t current_state, next_state;

    
    reg fall_count;
    reg dig_count;

    
    always @(posedge areset) begin
        current_state <= IDLE;
        fall_count <= 0;
        dig_count <= 0;
        walk_left <= 1;
 
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end

    
    always @(posedge clk) begin
        current_state <= next_state;

        case (current_state)
            IDLE: begin
                if (ground) begin
                    if (dig) begin
                        next_state <= DIG;
                    end else if (bump_left) begin
                        next_state <= WALK_RIGHT;
                    end else if (bump_right) begin
                        next_state <= WALK_LEFT;
                    end else begin
                        next_state <= WALK_LEFT;
 
                    end
                end else begin
                    next_state <= FALL;
                end
            end

            WALK_LEFT: begin
                if (ground) begin
                    if (dig) begin
                        next_state <= DIG;
                    end else if (bump_right) begin
                        next_state <= WALK_RIGHT;
                    end else begin
                        next_state <= WALK_LEFT;
 
                    end
                end else begin
                    next_state <= FALL;
                end
            end

            WALK_RIGHT: begin
                if (ground) begin
                    if (dig) begin
                        next_state <= DIG;
                    end else if (bump_left) begin
                        next_state <= WALK_LEFT;
                    end else begin
                        next_state <= WALK_RIGHT;
 
                    end
                end else begin
                    next_state <= FALL;
                end
            end

            FALL: begin
                if (ground) begin
                    next_state <= IDLE;
 
                    fall_count <= 0;
 
                end else begin
                    fall_count <= fall_count + 1;
                    if (fall_count == 20) begin
                        next_state <= IDLE;
 
                        fall_count <= 0;
 
                        walk_left <= 0;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end
                end
            end

            DIG: begin
                if (ground) begin
                    if (dig) begin
                        next_state <= DIG;
 
                    end else begin
                        next_state <= IDLE;
 
                    end
                end else begin
                    next_state <= FALL;
 
                end
            end

            default: begin
                next_state <= IDLE;
 
            end
        endcase
    end

    
    always @(current_state) begin
        case (current_state)
            IDLE: begin
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end

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

            DIG: begin
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 1;
            end

            default: begin
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end

endmodule
