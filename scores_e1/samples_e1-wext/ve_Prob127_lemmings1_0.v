
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left
);

    
    typedef enum {LEFT, RIGHT} state_t;

    
    state_t state = LEFT;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end else begin
            case (state)
                LEFT: begin
                    if (bump_left) begin
                        state <= RIGHT;
                    end else if (bump_right) begin
                        state <= LEFT;
                    end else begin
                        state <= LEFT;
                    end
                end
                RIGHT: begin
                    if (bump_left) begin
                        state <= LEFT;
                    end else if (bump_right) begin
                        state <= RIGHT;
                    end else begin
                        state <= RIGHT;
                    end
                end
            endcase
        end
    end

    
    assign walk_left = state == LEFT;

endmodule
