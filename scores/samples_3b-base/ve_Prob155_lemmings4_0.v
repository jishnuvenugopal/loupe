
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
        DIGGING
    } state_t;

    
    state_t current_state, next_state;

    
    logic fall_counter;
    logic splatter;

    
    always @(posedge areset) begin
        current_state <= WALK_LEFT;
        fall_counter <= 0;
        splatter <= 0;
    end

    
    always @(posedge clk) begin
        current_state <= next_state;

        
        case (current_state)
            WALK_LEFT: begin
                if (bump_right) begin
                    next_state <= WALK_RIGHT;
                end else if (ground && !fall_counter) begin
                    next_state <= WALK_LEFT;
                end else if (fall_counter) begin
                    next_state <= FALLING;
                end else if (dig && ground) begin
                    next_state <= DIGGING;
                end
            end
            WALK_RIGHT: begin
                if (bump_left) begin
                    next_state <= WALK_LEFT;
                end else if (ground && !fall_counter) begin
                    next_state <= WALK_RIGHT;
                end else if (fall_counter) begin
                    next_state <= FALLING;
                end else if (dig && ground) begin
                    next_state <= DIGGING;
                end
            end
            FALLING: begin
                if (ground) begin
                    next_state <= WALK_LEFT;
                end else if (fall_counter < 20) begin
                    fall_counter <= fall_counter + 1;
                end else begin
                    splatter <= 1;
                end
            end
            DIGGING: begin
                if (ground) begin
                    next_state <= WALK_LEFT;
                end else if (dig && ground) begin
                    next_state <= DIGGING;
                end
            end
        endcase
    end

    
    always @(*) begin
        walk_left = (current_state == WALK_LEFT);
        walk_right = (current_state == WALK_RIGHT);
        aaah = (current_state == FALLING);
        digging = (current_state == DIGGING);

        
        if (splatter) begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    end

endmodule
