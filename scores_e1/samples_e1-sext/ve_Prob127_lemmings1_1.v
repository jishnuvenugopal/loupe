
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    
    typedef enum {walking_left, walking_right} state_t;

    
    state_t state = walking_left;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= walking_left;
        end else begin
            case (state)
                walking_left: begin
                    if (bump_left) begin
                        state <= walking_right;
                    end else if (bump_right) begin
                        state <= walking_left;
                    end else begin
                        state <= walking_left;
                    end
                end
                walking_right: begin
                    if (bump_left) begin
                        state <= walking_right;
                    end else if (bump_right) begin
                        state <= walking_left;
                    end else begin
                        state <= walking_right;
                    end
                end
            endcase
        end
    end

    
    assign walk_left = (state == walking_left) ? 1'b1 : 1'b0;
    assign walk_right = (state == walking_right) ? 1'b1 : 1'b0;

endmodule
