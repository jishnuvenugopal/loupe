
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    
    localparam [1:0] WalkingLeft = 2'b00,
                     WalkingRight = 2'b01,
                     Falling = 2'b10;

    reg [1:0] current_state, next_state;
    reg prev_dir;
 

    
    always @(*) begin
        case (current_state)
            WalkingLeft: begin
                if (!ground) begin
                    next_state = Falling;
                end else if (bump_left || bump_right) begin
                    next_state = WalkingRight;
                end else begin
                    next_state = WalkingLeft;
                end
            end
            WalkingRight: begin
                if (!ground) begin
                    next_state = Falling;
                end else if (bump_left || bump_right) begin
                    next_state = WalkingLeft;
                end else begin
                    next_state = WalkingRight;
                end
            end
            Falling: begin
                if (ground) begin
                    next_state = (prev_dir) ? WalkingRight : WalkingLeft;
                end else begin
                    next_state = Falling;
                end
            end
            default: next_state = WalkingLeft;
        endcase
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WalkingLeft;
            prev_dir <= 0;
        end else begin
            current_state <= next_state;
            if (next_state == Falling) begin
                prev_dir <= (current_state == WalkingLeft) ? 0 : 1;
            end
        end
    end

    
    assign walk_left = (current_state == WalkingLeft);
    assign walk_right = (current_state == WalkingRight);
    assign aaah = (current_state == Falling);

endmodule
