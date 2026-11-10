
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left
);

    
    typedef enum {WalkingLeft, WalkingRight} state_t;

    
    state_t state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WalkingLeft;
        end else begin
            case (state)
                WalkingLeft: begin
                    if (bump_left) begin
                        state <= WalkingRight;
                    end else if (bump_right) begin
                        state <= WalkingLeft;
                    end else begin
                        state <= WalkingLeft;
                    end
                end
                WalkingRight: begin
                    if (bump_left) begin
                        state <= WalkingLeft;
                    end else if (bump_right) begin
                        state <= WalkingRight;
                    end else begin
                        state <= WalkingRight;
                    end
                end
            endcase
        end
    end

    
    assign walk_left = (state == WalkingLeft) ? 1'b1 : 1'b0;

endmodule
