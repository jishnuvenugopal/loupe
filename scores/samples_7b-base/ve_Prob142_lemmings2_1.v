
module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

    
    parameter STATE_WALK_LEFT = 2'b00;
    parameter STATE_WALK_RIGHT = 2'b01;

    
    reg [1:0] current_state;
    reg [1:0] next_state;

    
    assign walk_left = (current_state == STATE_WALK_LEFT);
    assign walk_right = (current_state == STATE_WALK_RIGHT);
    assign aaah = ~ground & (current_state != STATE_WALK_LEFT & current_state != STATE_WALK_RIGHT);

    
    always @(posedge clk) begin
        if (areset) begin
            current_state <= STATE_WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        if (areset) begin
            next_state = STATE_WALK_LEFT;
        end else if (bump_left) begin
            next_state = STATE_WALK_RIGHT;
        end else if (bump_right) begin
            next_state = STATE_WALK_LEFT;
        end else if (!ground) begin
            next_state = current_state;
        end else begin
            next_state = current_state;
        end
    end

endmodule
