
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output reg  walk_left,
    output reg  walk_right,
    output reg  aaah,
    output reg  digging
);

    
    typedef enum {IDLE, FALLING, DIGGING, WALKING_LEFT, WALKING_RIGHT} state_t;
    state_t state;

    
    reg falling;
    reg digging;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
            falling <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (ground == 1'b0) begin
                        state <= FALLING;
                        aaah <= 1'b1;
                    end else if (dig == 1'b1) begin
                        state <= DIGGING;
                        digging <= 1'b1;
                    end else begin
                        state <= WALKING_LEFT;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end
                end
                FALLING: begin
                    if (ground == 1'b1) begin
                        state <= WALKING_LEFT;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end
                end
                DIGGING: begin
                    if (ground == 1'b0) begin
                        state <= FALLING;
                        aaah <= 1'b1;
                    end
                end
                WALKING_LEFT: begin
                    if (bump_left == 1'b1) begin
                        state <= WALKING_RIGHT;
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end else if (bump_right == 1'b1) begin
                        state <= WALKING_LEFT;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else if (dig == 1'b1) begin
                        state <= DIGGING;
                        digging <= 1'b1;
                    end
                end
                WALKING_RIGHT: begin
                    if (bump_left == 1'b1) begin
                        state <= WALKING_LEFT;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else if (bump_right == 1'b1) begin
                        state <= WALKING_RIGHT;
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end else if (dig == 1'b1) begin
                        state <= DIGGING;
                        digging <= 1'b1;
                    end
                end
            endcase
        end
    end

    
    always @(*) begin
        case (state)
            IDLE: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
            FALLING: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
            end
            DIGGING: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b1;
            end
            WALKING_LEFT: begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
            WALKING_RIGHT: begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
                digging = 1'b0;
            end
        endcase
    end

endmodule
