
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

    
    parameter WALK_LEFT = 3'b000;
    parameter WALK_RIGHT = 3'b001;
    parameter FALLING = 3'b010;
    parameter DIGGING = 3'b011;
    parameter SPLAT = 3'b100;

    reg [2:0] current_state, next_state;
    reg [1:0] prev_dir;
 
    reg [4:0] fall_counter;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            prev_dir <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            current_state <= next_state;

            
            case (next_state)
                FALLING: begin
                    if (current_state != FALLING && current_state != DIGGING) begin
                        
                        prev_dir <= (current_state == WALK_LEFT) ? 1'b0 : 1'b1;
                    end
                end
                DIGGING: begin
                    if (current_state != DIGGING) begin
                        
                        prev_dir <= (current_state == WALK_LEFT) ? 1'b0 : 1'b1;
                    end
                end
                default: begin
                    
                end
            endcase

            
            if (current_state == FALLING) begin
                if (ground) begin
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end else begin
                fall_counter <= 0;
            end
        end
    end

    
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    next_state = (bump_left) ? WALK_RIGHT : WALK_LEFT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    next_state = (bump_right) ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter >= 20) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = (prev_dir == 0) ? WALK_LEFT : WALK_RIGHT;
                    end
                end else begin
                    next_state = FALLING;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
            end
            SPLAT: begin
                next_state = SPLAT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    
    assign walk_left = (current_state == WALK_LEFT) && (current_state != SPLAT);
    assign walk_right = (current_state == WALK_RIGHT) && (current_state != SPLAT);
    assign aaah = (current_state == FALLING);
    assign digging = (current_state == DIGGING);

endmodule
