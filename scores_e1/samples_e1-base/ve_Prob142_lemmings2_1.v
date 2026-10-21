
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    
    typedef enum {walking_left, walking_right} state_t;

    
    state_t current_state = walking_left;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= walking_left;
        end else begin
            case (current_state)
                walking_left: begin
                    if (bump_left) begin
                        current_state <= walking_right;
                    end else if (bump_right) begin
                        current_state <= walking_left;
                    end else if (ground) begin
                        current_state <= walking_left;
                    end else begin
                        current_state <= walking_left;
                    end
                end
                walking_right: begin
                    if (bump_left) begin
                        current_state <= walking_right;
                    end else if (bump_right) begin
                        current_state <= walking_left;
                    end else if (ground) begin
                        current_state <= walking_right;
                    end else begin
                        current_state <= walking_right;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end else begin
            case (current_state)
                walking_left: begin
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                end
                walking_right: begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                end
            endcase
        end
    end

endmodule
