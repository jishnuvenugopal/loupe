
module TopModule (
    input wire clk,
    input wire areset,
    input wire bump_left,
    input wire bump_right,
    input wire ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    
    typedef enum {state_left, state_right, state_fall} state_t;

    
    state_t current_state;

    
    initial begin
        current_state = state_left;
        walk_left = 1'b1;
        walk_right = 1'b0;
        aaah = 1'b0;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= state_left;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end else begin
            case (current_state)
                state_left:
                    if (bump_left) begin
                        current_state <= state_right;
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end else if (bump_right) begin
                        current_state <= state_left;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else if (ground == 0) begin
                        current_state <= state_fall;
                        aaah <= 1'b1;
                    end else begin
                        current_state <= state_left;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end
                state_right:
                    if (bump_right) begin
                        current_state <= state_left;
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end else if (bump_left) begin
                        current_state <= state_right;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else if (ground == 0) begin
                        current_state <= state_fall;
                        aaah <= 1'b1;
                    end else begin
                        current_state <= state_right;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end
                state_fall:
                    if (ground == 1) begin
                        current_state <= state_left;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                    end else begin
                        current_state <= state_fall;
                        aaah <= 1'b1;
                    end
            endcase
        end
    end

endmodule
