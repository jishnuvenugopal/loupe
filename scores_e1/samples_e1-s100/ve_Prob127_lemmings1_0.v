
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    
    typedef enum {left, right} state_t;

    
    state_t state;

    
    always @(posedge clk or posedge areset) begin
        if (arst) begin
            state <= left;
            walk_left <= 1'b0;
            walk_right <= 1'b0;
        end else begin
            case (state)
                left: begin
                    if (bump_left) begin
                        state <= right;
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end else if (bump_right) begin
                        state <= left;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else begin
                        state <= left;
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                    end
                end
                right: begin
                    if (bump_left) begin
                        state <= left;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else if (bump_right) begin
                        state <= right;
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end else begin
                        state <= right;
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                    end
                end
            endcase
        end
    end

    
    assign walk_left = state == left;
    assign walk_right = state == right;

endmodule
