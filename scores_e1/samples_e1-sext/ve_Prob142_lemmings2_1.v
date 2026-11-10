
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

typedef enum {WalkingLeft, WalkingRight, Falling, Ground} state_t;

state_t state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WalkingLeft;
        walk_left <= 0;
        walk_right <= 0;
        aaah <= 0;
    end else begin
        case (state)
            WalkingLeft: begin
                if (bump_left) begin
                    state <= WalkingRight;
                end else if (ground) begin
                    state <= Falling;
                end
            end
            WalkingRight: begin
                if (bump_right) begin
                    state <= WalkingLeft;
                end else if (ground) begin
                    state <= Falling;
                end
            end
            Falling: begin
                if (ground) begin
                    state <= Falling;
                end else begin
                    state <= Ground;
                end
            end
            Ground: begin
                if (bump_left) begin
                    state <= WalkingRight;
                end else if (bump_right) begin
                    state <= WalkingLeft;
                end
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
            end
        endcase
    end
end

assign walk_left = (state == WalkingLeft) ? 1 : 0;
assign walk_right = (state == WalkingRight) ? 1 : 0;
assign aaah = (state == Falling) ? 1 : 0;

endmodule
