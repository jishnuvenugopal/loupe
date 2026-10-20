
module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    
    typedef enum {LEFT, RIGHT} state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = LEFT;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= LEFT;
        end else begin
            
            case (current_state)
                LEFT: begin
                    if (bump_right) begin
                        next_state = RIGHT;
                    end else begin
                        next_state = LEFT;
                    end
                end
                RIGHT: begin
                    if (bump_left) begin
                        next_state = LEFT;
                    end else begin
                        next_state = RIGHT;
                    end
                end
            endcase

            
            current_state <= next_state;
        end
    end

    
    assign walk_left = (current_state == LEFT);
    assign walk_right = (current_state == RIGHT);

endmodule
