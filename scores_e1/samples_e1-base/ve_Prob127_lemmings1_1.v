
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output wire walk_left
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

    
    always @(posedge clk) begin
        if (state == WalkingLeft) begin
            walk_left <= 1'b1;
        end else begin
            walk_left <= 1'b0;
        end
    end

endmodule
