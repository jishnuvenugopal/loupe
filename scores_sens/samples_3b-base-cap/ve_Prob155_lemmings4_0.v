
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

    
    typedef enum logic [1:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALLING,
        DIGGING,
        SPLATTERED
    } state_t;

    
    state_t current_state, next_state;

    
    reg [3:0] fall_counter;

    
    initial begin
        current_state = WALK_LEFT;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
            fall_counter <= 4'b0;
        end else begin
            
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
                    end else if (fall_counter == 4'b1111) begin
                        next_state = SPLATTERED;
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
                SPLATTERED: begin
                    next_state = SPLATTERED;
                end
            endcase

            
            current_state <= next_state;

            
            walk_left <= (current_state == WALK_LEFT);
            walk_right <= (current_state == WALK_RIGHT);
            aaah <= (current_state == FALLING);
            digging <= (current_state == DIGGING);

            
            if (current_state == FALLING) begin
                fall_counter <= fall_counter + 1'b1;
            end else begin
                fall_counter <= 4'b0;
            end
        end
    end

endmodule
