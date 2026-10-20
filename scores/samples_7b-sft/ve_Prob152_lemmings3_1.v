
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    
    localparam [2:0] WL = 3'b000,
                     WR = 3'b001,
                     DIG_LEFT = 3'b010,
                     DIG_RIGHT = 3'b011,
                     FALL_LEFT = 3'b100,
                     FALL_RIGHT = 3'b101;

    reg [2:0] state, next_state;

    
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= WL;
        else
            state <= next_state;
    end

    
    always @(*) begin
        case (state)
            WL: begin
                if (dig && ground)
                    next_state = DIG_LEFT;
                else if (!ground)
                    next_state = FALL_LEFT;
                else if (bump_left || bump_right)
                    next_state = WR;
                else
                    next_state = WL;
            end
            WR: begin
                if (dig && ground)
                    next_state = DIG_RIGHT;
                else if (!ground)
                    next_state = FALL_RIGHT;
                else if (bump_left || bump_right)
                    next_state = WL;
                else
                    next_state = WR;
            end
            DIG_LEFT: begin
                next_state = ground ? DIG_LEFT : FALL_LEFT;
            end
            DIG_RIGHT: begin
                next_state = ground ? DIG_RIGHT : FALL_RIGHT;
            end
            FALL_LEFT: begin
                next_state = ground ? WL : FALL_LEFT;
            end
            FALL_RIGHT: begin
                next_state = ground ? WR : FALL_RIGHT;
            end
            default: next_state = WL;
        endcase
    end

    
    assign walk_left = (state == WL) || (state == FALL_LEFT);
    assign walk_right = (state == WR) || (state == FALL_RIGHT);
    assign aaah = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule
