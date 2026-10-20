
module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

    
    typedef enum reg [1:0] {
        WALK_LEFT,
        WALK_RIGHT
    } lemming_state_t;

    
    lemming_state_t lemming_state, next_state;

    
    assign walk_left = (lemming_state == WALK_LEFT) && (ground == 1);
    assign walk_right = (lemming_state == WALK_RIGHT) && (ground == 1);
    assign aaah = ~ground;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            lemming_state <= WALK_LEFT;
        end else begin
            lemming_state <= next_state;
        end
    end

    always_comb begin
        case (lemming_state)
            WALK_LEFT: begin
                if (bump_left)
                    next_state = WALK_RIGHT;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (bump_left)
                    next_state = WALK_RIGHT;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

endmodule
