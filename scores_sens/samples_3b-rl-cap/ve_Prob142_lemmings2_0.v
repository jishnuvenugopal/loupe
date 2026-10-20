
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output reg  walk_left,
    output reg  walk_right,
    output reg  aaah
);

    
    typedef enum {walking_left, walking_right} state_t;
    state_t current_state;

    
    initial begin
        current_state = walking_left;
        walk_left = 1'b1;
        walk_right = 1'b0;
        aaah = 1'b0;
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= walking_left;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end else begin
            case (current_state)
                walking_left: begin
                    if (ground == 1'b0) begin
                        aaah <= 1'b1;
                    end else begin
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end
                    if (bump_right) begin
                        current_state <= walking_right;
                    end
                    if (bump_left) begin
                        current_state <= walking_left;
                    end
                end
                walking_right: begin
                    if (ground == 1'b0) begin
                        aaah <= 1'b1;
                    end else begin
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end
                    if (bump_left) begin
                        current_state <= walking_left;
                    end
                    if (bump_right) begin
                        current_state <= walking_right;
                    end
                end
            endcase
        end
    end

endmodule
