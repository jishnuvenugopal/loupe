
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


localparam LEFT = 2'b00;
localparam RIGHT = 2'b01;
localparam FALLING_LEFT = 2'b10;
localparam FALLING_RIGHT = 2'b11;

reg [1:0] current_state, next_state;


always @(*) begin
    case (current_state)
        LEFT: begin
            if (!ground)
                next_state = FALLING_LEFT;
            else if (bump_left || bump_right)
                next_state = RIGHT;
            else
                next_state = LEFT;
        end
        RIGHT: begin
            if (!ground)
                next_state = FALLING_RIGHT;
            else if (bump_left || bump_right)
                next_state = LEFT;
            else
                next_state = RIGHT;
        end
        FALLING_LEFT: begin
            next_state = ground ? LEFT : FALLING_LEFT;
        end
        FALLING_RIGHT: begin
            next_state = ground ? RIGHT : FALLING_RIGHT;
        end
        default: next_state = LEFT;
    endcase
end


always @(posedge clk, posedge areset) begin
    if (areset)
        current_state <= LEFT;
    else
        current_state <= next_state;
end


assign walk_left = (current_state == LEFT);
assign walk_right = (current_state == RIGHT);
assign aaah = (current_state == FALLING_LEFT || current_state == FALLING_RIGHT);

endmodule
