
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

    
    localparam IDLE = 3'b000;
    localparam WALKING_LEFT = 3'b001;
    localparam WALKING_RIGHT = 3'b010;
    localparam FALLING = 3'b011;
    localparam FALLING_LEFT = 3'b100;
    localparam FALLING_RIGHT = 3'b101;
    localparam SPLATTERED = 3'b110;

    reg [1:0] state, next_state;
    reg [4:0] fall_count;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING_LEFT;
            fall_count <= 0;
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end else begin
            state <= next_state;
            case (state)
                WALKING_LEFT:
                    begin
                        fall_count <= 0;
                        if (ground == 0) begin
                            next_state <= FALLING_LEFT;
                            aaah <= 1;
                            digging <= 0;
                            walk_left <= 0;
                            walk_right <= 0;
                        end else if (bump_left) begin
                            next_state <= WALKING_RIGHT;
                            aaah <= 0;
                            digging <= 0;
                        end else if (dig && ground == 1) begin
                            next_state <= DIGGING_LEFT;
                            aaah <= 0;
                            walk_left <= 0;
                            walk_right <= 0;
                        end else begin
                            next_state <= WALKING_LEFT;
                            aaah <= 0;
                            digging <= 0;
                        end
                    end
                WALKING_RIGHT:
                    begin
                        fall_count <= 0;
                        if (ground == 0) begin
                            next_state <= FALLING_RIGHT;
                            aaah <= 1;
                            digging <= 0;
                            walk_left <= 0;
                            walk_right <= 0;
                        end else if (bump_right) begin
                            next_state <= WALKING_LEFT;
                            aaah <= 0;
                            digging <= 0;
                        end else if (dig && ground == 1) begin
                            next_state <= DIGGING_RIGHT;
                            aaah <= 0;
                            walk_left <= 0;
                            walk_right <= 0;
                        end else begin
                            next_state <= WALKING_RIGHT;
                            aaah <= 0;
                            digging <= 0;
                        end
                    end
                FALLING:
                    begin
                        fall_count <= fall_count + 1;
                        if (fall_count >= 20) begin
                            next_state <= SPLATTERED;
                        end else if (ground == 1) begin
                            next_state <= WALKING_LEFT ? WALKING_LEFT : WALKING_RIGHT;
                            fall_count <= 0;
                            aaah <= 0;
                            digging <= 0;
                        end else begin
                            next_state <= FALLING;
                            aaah <= 1;
                            digging <= 0;
                        end
                    end
                FALLING_LEFT:
                    begin
                        fall_count <= fall_count + 1;
                        if (fall_count >= 20) begin
                            next_state <= SPLATTERED;
                        end else if (ground == 1) begin
                            next_state <= WALKING_LEFT;
                            fall_count <= 0;
                            aaah <= 0;
                            digging <= 0;
                        end else begin
                            next_state <= FALLING_LEFT;
                            aaah <= 1;
                            digging <= 0;
                        end
                    end
                FALLING_RIGHT:
                    begin
                        fall_count <= fall_count + 1;
                        if (fall_count >= 20) begin
                            next_state <= SPLATTERED;
                        end else if (ground == 1) begin
                            next_state <= WALKING_RIGHT;
                            fall_count <= 0;
                            aaah <= 0;
                            digging <= 0;
                        end else begin
                            next_state <= FALLING_RIGHT;
                            aaah <= 1;
                            digging <= 0;
                        end
                    end
                SPLATTERED:
                    begin
                        next_state <= SPLATTERED;
                        aaah <= 0;
                        digging <= 0;
                        walk_left <= 0;
                        walk_right <= 0;
                    end
                default:
                    next_state <= IDLE;
            endcase
        end
    end

    assign walk_left = (state == WALKING_LEFT || state == FALLING_LEFT);
    assign walk_right = (state == WALKING_RIGHT || state == FALLING_RIGHT);
    assign digging = (state == DIGGING_LEFT || state == DIGGING_RIGHT);

endmodule
