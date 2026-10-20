
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);


localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;


reg [1:0] state, next_state;


assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);


always @(posedge clk) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end


always @(*) begin
    next_state = state;

    case (state)
        WALK_LEFT:
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = FALLING;
                digging <= 0;
            end else if (!ground) begin
                next_state = FALLING;
                digging <= 0;
            end else if (dig) begin
                next_state = DIGGING;
                digging <= 1;
            end
        WALK_RIGHT:
            if (bump_left) begin
                next_state = FALLING;
                digging <= 0;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (!ground) begin
                next_state = FALLING;
                digging <= 0;
            end else if (dig) begin
                next_state = DIGGING;
                digging <= 1;
            end
        FALLING:
            if (ground) begin
                if (state == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                end else if (state == WALK_RIGHT) begin
                    next_state = WALK_RIGHT;
                end
            end
        DIGGING:
            if (!ground) begin
                next_state = FALLING;
                digging <= 0;
            end else if (ground) begin
                if (state == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                end else if (state == WALK_RIGHT) begin
                    next_state = WALK_RIGHT;
                end
            end
    endcase
end

endmodule
