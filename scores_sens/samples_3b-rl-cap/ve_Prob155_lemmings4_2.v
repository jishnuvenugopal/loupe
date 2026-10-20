
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

    
    reg [3:0] state;
    reg [3:0] next_state;
    reg [3:0] fall_count;

    
    localparam [3:0] IDLE = 4'd0;
    localparam [3:0] WALK_LEFT = 4'd1;
    localparam [3:0] WALK_RIGHT = 4'd2;
    localparam [3:0] FALLING = 4'd3;
    localparam [3:0] DIGGING = 4'd4;

    
    always @(*) begin
        case (state)
            IDLE: begin
                if (areset) begin
                    next_state = WALK_LEFT;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (ground) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = FALLING;
                end
            end
            WALK_LEFT: begin
                if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (ground) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = FALLING;
                end
            end
            WALK_RIGHT: begin
                if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (ground) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end
            FALLING: begin
                if (ground) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = FALLING;
                end
            end
            DIGGING: begin
                if (ground) begin
                    next_state = DIGGING;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    
    always @(*) begin
        case (state)
            IDLE: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
            WALK_LEFT: begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
            WALK_RIGHT: begin
                walk_left = 1'b0;
                walk_right = 1'b1;
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
            default: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
        endcase
    end

    
    always @(posedge clk) begin
        if (areset) begin
            state <= IDLE;
            fall_count <= 4'd0;
        end else begin
            state <= next_state;
            if (state == FALLING) begin
                fall_count <= fall_count + 1'b1;
                if (fall_count == 4'd20) begin
                    state <= IDLE;
                    fall_count <= 4'd0;
                end
            end
        end
    end

endmodule
