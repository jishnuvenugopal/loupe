
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    
    typedef enum reg [3:0] {WALK_LEFT, WALK_RIGHT, FALL, DIG, SPLAT} state_t;
    state_t current_state, next_state;
    integer fall_counter;

    
    assign walk_left = (current_state == WALK_LEFT) & ~falling;
    assign walk_right = (current_state == WALK_RIGHT) & ~falling;
    assign aaah = (current_state == FALL);
    assign digging = (current_state == DIG);
    reg [1:0] fall_duration;
    reg digging_flag;

    
    reg falling;
    assign falling = (current_state == FALL & ground == 0);

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
            fall_duration <= 0;
            digging_flag <= 0;
        end else begin
            if (!falling) begin
                fall_counter <= 0;
            end else if (fall_counter < 20) begin
                fall_counter <= fall_counter + 1;
            end

            current_state <= next_state;
            digging_flag <= 0;
        end
    end

    
    always @(*) begin
        case (current_state)
            WALK_LEFT:
                if (ground == 0)
                    next_state = FALL;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else if (dig & ground)
                    next_state = DIG;
                else
                    next_state = WALK_LEFT;

            WALK_RIGHT:
                if (ground == 0)
                    next_state = FALL;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else if (dig & ground)
                    next_state = DIG;
                else
                    next_state = WALK_RIGHT;

            FALL:
                if (dig & ground & !digging_flag)
                    next_state = DIG;
                else if (fall_counter >= 20)
                    next_state = SPLAT;
                else if (ground)
                    next_state = WALK_LEFT;
                else
                    next_state = FALL;

            DIG:
                if (ground == 0)
                    next_state = FALL;
                else
                    next_state = DIG;

            SPLAT:
                next_state = SPLAT;
        endcase
    end

endmodule
