
module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output wire walk_left,
    output wire walk_right,
    output wire aaah,
    output wire digging
);

    
    typedef enum reg [2:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALLING,
        DIGGING
    } state_t;

    
    state_t state, next_state;

    
    reg fall_timer;

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        fall_timer = 0;

        case (state)
            WALK_LEFT:
                if (ground == 0) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                end
                walk_left = 1;

            WALK_RIGHT:
                if (ground == 0) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                end
                walk_right = 1;

            FALLING:
                fall_timer = fall_timer + 1;
                if (ground == 1) begin
                    next_state = state;
 
                end

            DIGGING:
                if (ground == 0) begin
                    next_state = FALLING;
                    aaah = 1;
                end
                digging = 1;

            default:
                next_state = WALK_LEFT;
        endcase

        
        if (state == FALLING && fall_timer >= 20) begin
            state = WALK_LEFT;
 
        end
    end

endmodule
