
module TopModule(
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
    
    localparam [3:0]
        IDLE_LEFT    = 4'd0,
        IDLE_RIGHT   = 4'd1,
        FALLING_LEFT = 4'd2,
        FALLING_RIGHT= 4'd3,
        DIG_LEFT     = 4'd4,
        DIG_RIGHT    = 4'd5;

    reg [3:0] current_state, next_state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= IDLE_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        next_state = current_state;
 
        case (current_state)
            IDLE_LEFT: begin
                if (!ground)
                    next_state = FALLING_LEFT;
                else if (dig)
                    next_state = DIG_LEFT;
                else begin
                    if (bump_left)
                        next_state = IDLE_RIGHT;
                    else if (bump_right)
                        next_state = IDLE_LEFT;
 
                end
            end

            IDLE_RIGHT: begin
                if (!ground)
                    next_state = FALLING_RIGHT;
                else if (dig)
                    next_state = DIG_RIGHT;
                else begin
                    if (bump_left)
                        next_state = IDLE_LEFT;
                    else if (bump_right)
                        next_state = IDLE_RIGHT;
 
                end
            end

            DIG_LEFT: begin
                if (!ground)
                    next_state = FALLING_LEFT;
                
                else
                    next_state = DIG_LEFT;
            end

            DIG_RIGHT: begin
                if (!ground)
                    next_state = FALLING_RIGHT;
                
                else
                    next_state = DIG_RIGHT;
            end

            FALLING_LEFT: begin
                if (ground)
                    next_state = IDLE_LEFT;
 
                
                else
                    next_state = FALLING_LEFT;
            end

            FALLING_RIGHT: begin
                if (ground)
                    next_state = IDLE_RIGHT;
 
                
                else
                    next_state = FALLING_RIGHT;
            end

            default: next_state = IDLE_LEFT;
        endcase
    end

    
    assign walk_left = (current_state == IDLE_LEFT) || (current_state == DIG_LEFT);
    assign walk_right = (current_state == IDLE_RIGHT) || (current_state == DIG_RIGHT);
    assign aaah = (current_state == FALLING_LEFT) || (current_state == FALLING_RIGHT);
    assign digging = (current_state == DIG_LEFT) || (current_state == DIG_RIGHT);

endmodule
