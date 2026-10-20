
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

    
    typedef enum {walking_left, walking_right, falling} state_t;
    state_t state;

    
    reg walk_left_reg;
    reg walk_right_reg;
    reg aaah_reg;

    
    

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state   <= walking_left;
            walk_left_reg <= 1'b0;
            walk_right_reg <= 1'b1;
            aaah_reg <= 1'b0;
        end else begin
            case (state)
                walking_left: begin
                    if (ground == 1'b0) begin
                        state <= falling;
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b1;
                    end else if (bump_left) begin
                        state <= walking_right;
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b1;
                        aaah_reg <= 1'b0;
                    end else if (bump_right) begin
                        state <= walking_left;
                        walk_left_reg <= 1'b1;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b0;
                    end else begin
                        walk_left_reg <= 1'b1;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b0;
                    end
                end
                walking_right: begin
                    if (ground == 1'b0) begin
                        state <= falling;
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b1;
                    end else if (bump_right) begin
                        state <= walking_left;
                        walk_left_reg <= 1'b1;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b0;
                    end else if (bump_left) begin
                        state <= walking_right;
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b1;
                        aaah_reg <= 1'b0;
                    end else begin
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b1;
                        aaah_reg <= 1'b0;
                    end
                end
                falling: begin
                    if (ground == 1'b1) begin
                        state <= walking_left;
                        walk_left_reg <= 1'b1;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b0;
                    end else begin
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b0;
                        aaah_reg <= 1'b1;
                    end
                end
                default: begin
                    state <= walking_left;
                    walk_left_reg <= 1'b1;
                    walk_right_reg <= 1'b0;
                    aaah_reg <= 1'b0;
                end
            endcase
        end
    end

    assign walk_left = walk_left_reg;
    assign walk_right = walk_right_reg;
    assign aaah = aaah_reg;

endmodule
