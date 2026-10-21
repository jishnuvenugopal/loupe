
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output wire walk_left
);

    
    typedef enum {WalkingLeft, WalkingRight} State;

    
    State state;

    
    wire walk_left;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WalkingLeft;
            walk_left <= 1'b0;
        end else begin
            case (state)
                WalkingLeft: begin
                    if (bump_left) begin
                        state <= WalkingRight;
                        walk_left <= 1'b0;
                    end else if (bump_right) begin
                        state <= WalkingLeft;
                        walk_left <= 1'b0;
                    end else begin
                        state <= WalkingLeft;
                        walk_left <= 1'b1;
                    end
                end
                WalkingRight: begin
                    if (bump_left) begin
                        state <= WalkingLeft;
                        walk_left <= 1'b0;
                    end else if (bump_right) begin
                        state <= WalkingRight;
                        walk_left <= 1'b0;
                    end else begin
                        state <= WalkingRight;
                        walk_left <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule
