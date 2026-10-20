
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

    
    localparam [2:0] WL     = 3'b000,
                     WR     = 3'b001,
                     FALL   = 3'b010,
                     DIG    = 3'b011,
                     SPLAT  = 3'b100;

    reg [2:0] state, next_state;
    reg [4:0] fall_counter;
    reg prev_dir;
 

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
            prev_dir <= 0;
            fall_counter <= 0;
        end else begin
            state <= next_state;

            
            if (state == FALL) begin
                if (next_state == FALL)
                    fall_counter <= fall_counter + 1;
                else
                    fall_counter <= 0;
            end else
                fall_counter <= 0;

            if (next_state == FALL && state != FALL)
                prev_dir <= (state == WL) ? 1'b0 : 1'b1;
        end
    end

    
    always @(*) begin
        next_state = state;
        case (state)
            WL: begin
                if (!ground)
                    next_state = FALL;
                else if (dig && ground)
                    next_state = DIG;
                else if (bump_left || bump_right)
                    next_state = WR;
            end
            WR: begin
                if (!ground)
                    next_state = FALL;
                else if (dig && ground)
                    next_state = DIG;
                else if (bump_left || bump_right)
                    next_state = WL;
            end
            FALL: begin
                if (ground) begin
                    next_state = (fall_counter >= 20) ? SPLAT : (prev_dir ? WR : WL);
                end
            end
            DIG: begin
                next_state = (!ground) ? FALL : DIG;
            end
            SPLAT: next_state = SPLAT;
            default: next_state = WL;
        endcase
    end

    
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule
