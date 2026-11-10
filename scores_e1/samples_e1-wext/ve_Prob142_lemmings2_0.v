
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

    
    reg [1:0] state;
    reg [1:0] prev_state;
    reg [1:0] direction;
    reg [1:0] fall_count;

    
    initial begin
        state = WalkingLeft;
        prev_state = WalkingLeft;
        direction = WalkingLeft;
        fall_count = 0;
    end

    
    always @(posedge clk) begin
        if (areset) begin
            state <= WalkingLeft;
            prev_state <= WalkingLeft;
            direction <= WalkingLeft;
            fall_count <= 0;
        end else begin
            prev_state <= state;
            case (state)
                WalkingLeft:
                    if (bump_left) begin
                        state <= WalkingRight;
                        direction <= WalkingRight;
                    end else if (bump_right) begin
                        state <= WalkingLeft;
                        direction <= WalkingLeft;
                    end else if (ground) begin
                        state <= Falling;
                        fall_count <= fall_count + 1;
                    end else begin
                        state <= WalkingLeft;
                    end
                WalkingRight:
                    if (bump_left) begin
                        state <= WalkingRight;
                        direction <= WalkingLeft;
                    end else if (bump_right) begin
                        state <= WalkingLeft;
                        direction <= WalkingRight;
                    end else if (ground) begin
                        state <= Falling;
                        fall_count <= fall_count + 1;
                    end else begin
                        state <= WalkingRight;
                    end
                Falling:
                    if (ground) begin
                        state <= WalkingLeft;
                        fall_count <= 0;
                    end else begin
                        state <= Falling;
                    end
            endcase
        end
    end

    
    assign walk_left = (state == WalkingLeft);
    assign walk_right = (state == WalkingRight);
    assign aaah = (state == Falling && fall_count == 0);

endmodule
