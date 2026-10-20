
module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    
    typedef enum logic [2:0] {
        WALK_LEFT,
        WALK_RIGHT,
        DIGGING,
        FALLING
    } state_t;

    state_t current_state, next_state;

    
    assign walk_left = (current_state == WALK_LEFT);
    assign walk_right = (current_state == WALK_RIGHT);
    assign aaah = (current_state == FALLING);
    assign digging = (current_state == DIGGING);

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        
        next_state = current_state;

        case (current_state)
            WALK_LEFT:
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else if (dig) begin
                    next_state = DIGGING;
                end

            WALK_RIGHT:
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else if (dig) begin
                    next_state = DIGGING;
                end

            DIGGING:
                if (ground == 0) begin
                    next_state = FALLING;
                end else begin
                    next_state = current_state;
                end

            FALLING:
                if (ground == 1) begin
                    next_state = WALK_LEFT;
 
                end

            default:
                current_state <= WALK_LEFT;
        endcase
    end

endmodule
