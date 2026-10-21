
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
    reg [1:0] next_walk_left;
    reg [1:0] next_walk_right;
    reg [1:0] next_aaah;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WalkingLeft;
            next_state <= WalkingLeft;
            next_walk_left <= 0;
            next_walk_right <= 0;
            next_aaah <= 0;
        end else begin
            state <= next_state;
            next_walk_left <= next_walk_left;
            next_walk_right <= next_walk_right;
            next_aaah <= next_aaah;
        end
    end

    
    always @(posedge clk) begin
        case (state)
            WalkingLeft: begin
                if (bump_left) begin
                    next_state <= WalkingRight;
                    next_walk_left <= 0;
                    next_walk_right <= 1;
                    next_aaah <= 0;
                end else if (bump_right) begin
                    next_state <= WalkingLeft;
                    next_walk_left <= 1;
                    next_walk_right <= 0;
                    next_aaah <= 0;
                end else if (ground == 0) begin
                    next_state <= WalkingLeft;
                    next_walk_left <= 0;
                    next_walk_right <= 0;
                    next_aaah <= 1;
                end else begin
                    next_state <= WalkingLeft;
                    next_walk_left <= 0;
                    next_walk_right <= 0;
                    next_aaah <= 0;
                end
            end
            WalkingRight: begin
                if (bump_left) begin
                    next_state <= WalkingLeft;
                    next_walk_left <= 1;
                    next_walk_right <= 0;
                    next_aaah <= 0;
                end else if (bump_right) begin
                    next_state <= WalkingRight;
                    next_walk_left <= 0;
                    next_walk_right <= 1;
                    next_aaah <= 0;
                end else if (ground == 0) begin
                    next_state <= WalkingRight;
                    next_walk_left <= 0;
                    next_walk_right <= 0;
                    next_aaah <= 1;
                end else begin
                    next_state <= WalkingRight;
                    next_walk_left <= 0;
                    next_walk_right <= 0;
                    next_aaah <= 0;
                end
            end
        endcase
    end

    
    always @(posedge clk) begin
        next_walk_left <= state[0];
        next_walk_right <= state[1];
        next_aaah <= next_aaah;
    end

    
    assign walk_left = next_walk_left;
    assign walk_right = next_walk_right;
    assign aaah = next_aaah;

endmodule
