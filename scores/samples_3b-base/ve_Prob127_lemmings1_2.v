
module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    
    typedef enum {WALK_LEFT, WALK_RIGHT} state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = WALK_LEFT;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            
            current_state <= WALK_LEFT;
        end else begin
            
            case (current_state)
                WALK_LEFT: begin
                    if (bump_right) begin
                        next_state = WALK_RIGHT;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end
                WALK_RIGHT: begin
                    if (bump_left) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end
            endcase

            
            current_state <= next_state;
        end
    end

    
    assign walk_left = (current_state == WALK_LEFT);
    assign walk_right = (current_state == WALK_RIGHT);

endmodule
