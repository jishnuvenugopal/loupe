
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

    
    localparam IDLE_L = 2'b00;
    localparam IDLE_R = 2'b01;
    localparam FALLING = 2'b10;
    localparam DIG = 2'b11;
    
    reg [1:0] state, next_state;
    reg dir_reg;
 
    reg prev_dir;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE_L;
            dir_reg <= 0;
            prev_dir <= 0;
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end else begin
            case(state)
                IDLE_L: begin
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                    prev_dir <= dir_reg;
                end
                IDLE_R: begin
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                    prev_dir <= dir_reg;
                end
                FALLING: begin
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end
                DIG: begin
                    aaah <= 0;
                    walk_left <= 0;
                    walk_right <= 0;
                    digging <= 1;
                end
                default: begin
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end
            endcase
            state <= next_state;
        end
    end

    
    always @* begin
        next_state = state;
        case (state)
            IDLE_L: begin
                if (!ground) begin
                    next_state = FALLING;
                    prev_dir = dir_reg;
                end else if (dig && ground) begin
                    next_state = DIG;
                    prev_state = IDLE_L;
                end else begin
                    
                    if (bump_left) dir_reg = 1;
 
                    else if (bump_right) dir_reg = 0;
 
                    else if (bump_left && bump_right) dir_reg = !dir_reg;
                    next_state = IDLE_L;
 
                end
            end
            IDLE_R: begin
                if (!ground) begin
                    next_state = FALLING;
                    prev_dir = dir_reg;
                end else if (dig && ground) begin
                    next_state = DIG;
                    prev_state = IDLE_R;
                end else begin
                    
                    if (bump_right) dir_reg = 0;
 
                    else if (bump_left) dir_reg = 1;
 
                    else if (bump_left && bump_right) dir_reg = !dir_reg;
                    next_state = IDLE_R;
                end
            end
            FALLING: begin
                if (ground) state = prev_dir ? IDLE_R : IDLE_L;
                else next_state = FALLING;
            end
            DIG: begin
                if (!ground) next_state = FALLING;
                else next_state = (prev_dir) ? IDLE_R : IDLE_L;
            end
        endcase
    end

endmodule
