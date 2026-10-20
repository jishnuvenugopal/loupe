
module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    
    typedef enum {LEFT, RIGHT} State_t;
    State_t current_state, next_state;

    
    initial begin
        current_state = LEFT;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
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
    end

    
    always @(*) begin
        case (current_state)
            LEFT: begin
                walk_left = 1'b1;
                walk_right = 1'b0;
            end
            RIGHT: begin
                walk_left = 1'b0;
                walk_right = 1'b1;
            end
        endcase
    end

endmodule
