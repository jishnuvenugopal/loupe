
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

    
    typedef enum {WalkingLeft, WalkingRight} State;

    
    reg [1:0] state;

    
    reg [1:0] next_state;

    
    reg [1:0] next_aaah;

    
    reg [1:0] next_walk_left;
    reg [1:0] next_walk_right;

    
    initial begin
        state = WalkingLeft;
        next_state = WalkingLeft;
        next_aaah = 0;
        next_walk_left = 0;
        next_walk_right = 0;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WalkingLeft;
            next_state <= WalkingLeft;
            next_aaah <= 0;
            next_walk_left <= 0;
            next_walk_right <= 0;
        end else begin
            case (state)
                WalkingLeft: begin
                    if (bump_left) begin
                        next_state <= WalkingRight;
                        next_aaah <= 0;
                        next_walk_left <= 0;
                        next_walk_right <= 1;
                    end else if (bump_right) begin
                        next_state <= WalkingLeft;
                        next_aaah <= 0;
                        next_walk_left <= 1;
                        next_walk_right <= 0;
                    end else if (ground) begin
                        next_state <= WalkingLeft;
                        next_aaah <= 0;
                        next_walk_left <= 0;
                        next_walk_right <= 0;
                    end else begin
                        next_state <= WalkingLeft;
                        next_aaah <= 0;
                        next_walk_left <= 0;
                        next_walk_right <= 0;
                    end
                end
                WalkingRight: begin
                    if (bump_left) begin
                        next_state <= WalkingRight;
                        next_aaah <= 0;
                        next_walk_left <= 0;
                        next_walk_right <= 1;
                    end else if (bump_right) begin
                        next_state <= WalkingLeft;
                        next_aaah <= 0;
                        next_walk_left <= 1;
                        next_walk_right <= 0;
                    end else if (ground) begin
                        next_state <= WalkingRight;
                        next_aaah <= 0;
                        next_walk_left <= 0;
                        next_walk_right <= 0;
                    end else begin
                        next_state <= WalkingRight;
                        next_aaah <= 0;
                        next_walk_left <= 0;
                        next_walk_right <= 0;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
        end else begin
            walk_left <= next_walk_left;
            walk_right <= next_walk_right;
            aaah <= next_aaah;
        end
    end

endmodule
