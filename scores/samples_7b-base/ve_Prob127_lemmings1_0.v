
module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    
    localparam IDLE = 2'b00;
    localparam WALK_LEFT = 2'b01;
    localparam WALK_RIGHT = 2'b10;

    
    reg [1:0] state;

    
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            case (state)
                IDLE: begin
                    if (bump_left || bump_right) begin
                        state <= (bump_left) ? WALK_RIGHT : WALK_LEFT;
                    end
                end
                WALK_LEFT: begin
                    if (bump_right) begin
                        state <= WALK_RIGHT;
                    end
                end
                WALK_RIGHT: begin
                    if (bump_left) begin
                        state <= WALK_LEFT;
                    end
                end
            endcase
        end
    end

endmodule
