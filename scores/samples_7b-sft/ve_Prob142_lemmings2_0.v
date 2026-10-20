
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

    reg [1:0] current_state, next_state;

    parameter W_LEFT      = 2'b00;
    parameter W_RIGHT     = 2'b01;
    parameter FALLING_LEFT= 2'b10;
    parameter FALLING_RIGHT=2'b11;

    
    always @(posedge clk or posedge areset) begin
        if (areset) current_state <= W_LEFT;
        else        current_state <= next_state;
    end

    
    always @(*) begin
        case (current_state)
            W_LEFT: begin
                if (!ground)      next_state = FALLING_LEFT;
                else if (bump_left || bump_right) next_state = W_RIGHT;
                else              next_state = W_LEFT;
            end
            W_RIGHT: begin
                if (!ground)      next_state = FALLING_RIGHT;
                else if (bump_left || bump_right) next_state = W_LEFT;
                else              next_state = W_RIGHT;
            end
            FALLING_LEFT:  next_state = ground ? W_LEFT : FALLING_LEFT;
            FALLING_RIGHT: next_state = ground ? W_RIGHT : FALLING_RIGHT;
            default:       next_state = W_LEFT;
        endcase
    end

    
    assign walk_left  = (current_state == W_LEFT);
    assign walk_right = (current_state == W_RIGHT);
    assign aaah       = (current_state == FALLING_LEFT || current_state == FALLING_RIGHT);

endmodule
