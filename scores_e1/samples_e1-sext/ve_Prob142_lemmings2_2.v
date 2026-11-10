
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
    reg [1:0] last_fall;
    reg [1:0] ground_state;

    
    reg [3:0] cycle_counter;

    
    initial begin
        state = WalkingLeft;
        prev_state = WalkingLeft;
        direction = WalkingLeft;
        last_fall = 0;
        ground_state = 1;
        cycle_counter = 0;
    end

    
    always @(posedge clk) begin
        if (areset) begin
            state = WalkingLeft;
            prev_state = WalkingLeft;
            direction = WalkingLeft;
            last_fall = 0;
            ground_state = 1;
            cycle_counter = 0;
        end else begin
            prev_state = state;
            case (state)
                WalkingLeft:
                    if (bump_left) begin
                        state = WalkingRight;
                    end else if (bump_right) begin
                        state = WalkingLeft;
                    end else if (ground) begin
                        state = Falling;
                    end
                    break;
                WalkingRight:
                    if (bump_left) begin
                        state = WalkingRight;
                    end else if (bump_right) begin
                        state = WalkingLeft;
                    end else if (ground) begin
                        state = Falling;
                    end
                    break;
                Falling:
                    if (ground) begin
                        state = Resumed;
                    end
                    break;
                Resumed:
                    if (ground) begin
                        state = WalkingLeft;
                    end else if (bump_left) begin
                        state = WalkingRight;
                    end else if (bump_right) begin
                        state = WalkingLeft;
                    end
                    break;
            endcase

            
            if (state == Falling) begin
                cycle_counter = 0;
            end else if (state == Resumed) begin
                cycle_counter = 0;
            end else if (state == WalkingLeft || state == WalkingRight) begin
                cycle_counter++;
            end

            
            walk_left = state == WalkingLeft;
            walk_right = state == WalkingRight;
            aaah = state == Falling && ground;
        end
    end

endmodule
