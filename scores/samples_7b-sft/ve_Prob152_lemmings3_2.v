
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

    reg [1:0] state, next_state;
    reg prev_dir;
 

    localparam WL = 2'b00,
               WR = 2'b01,
               FALL = 2'b10,
               DIG = 2'b11;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
            prev_dir <= 0;
        end else begin
            state <= next_state;
            if (next_state == FALL) begin
                prev_dir <= (state == WL) ? 0 : 1;
            end
        end
    end

    always @(*) begin
        case (state)
            WL: begin
                if (!ground)
                    next_state = FALL;
                else if (dig)
                    next_state = DIG;
                else if (bump_left || bump_right)
                    next_state = WR;
                else
                    next_state = WL;
            end
            WR: begin
                if (!ground)
                    next_state = FALL;
                else if (dig)
                    next_state = DIG;
                else if (bump_left || bump_right)
                    next_state = WL;
                else
                    next_state = WR;
            end
            FALL: begin
                if (ground)
                    next_state = prev_dir ? WR : WL;
                else
                    next_state = FALL;
            end
            DIG: begin
                if (!ground)
                    next_state = FALL;
                else if (dig)
                    next_state = DIG;
                else
                    next_state = DIG;
            end
            default: next_state = WL;
        endcase
    end

    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule
