
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
    reg [1:0] previous_state;
    reg [1:0] next_state;
    reg [1:0] direction;
    reg [1:0] fall_counter;

    
    initial begin
        state = WalkingLeft;
        previous_state = WalkingLeft;
        direction = WalkingLeft;
        fall_counter = 0;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WalkingLeft;
            previous_state <= WalkingLeft;
            direction <= WalkingLeft;
            fall_counter <= 0;
        end else begin
            previous_state <= state;
            state <= next_state;
            direction <= next_direction;
            fall_counter <= fall_counter + 1;
        end
    end

    
    always @(*) begin
        case (state)
            WalkingLeft:
                if (ground == 0) begin
                    next_state = Falling;
                    next_direction = WalkingRight;
                end else if (bump_left == 1) begin
                    next_state = WalkingRight;
                    next_direction = WalkingRight;
                end else if (bump_right == 1) begin
                    next_state = WalkingLeft;
                    next_direction = WalkingLeft;
                end else begin
                    next_state = WalkingLeft;
                    next_direction = WalkingLeft;
                end
            WalkingRight:
                if (ground == 0) begin
                    next_state = Falling;
                    next_direction = WalkingLeft;
                end else if (bump_left == 1) begin
                    next_state = WalkingLeft;
                    next_direction = WalkingLeft;
                end else if (bump_right == 1) begin
                    next_state = WalkingRight;
                    next_direction = WalkingRight;
                end else begin
                    next_state = WalkingRight;
                    next_direction = WalkingRight;
                end
            Falling:
                if (fall_counter == 10) begin 
                    next_state = WalkingLeft;
                    next_direction = WalkingLeft;
                end else begin
                    next_state = Falling;
                    next_direction = WalkingLeft;
                end
            default:
                next_state = WalkingLeft;
                next_direction = WalkingLeft;
        endcase
    end

    
    always @(*) begin
        walk_left = direction == WalkingLeft;
        walk_right = direction == WalkingRight;
        aaah = ground == 0;
    end

endmodule
