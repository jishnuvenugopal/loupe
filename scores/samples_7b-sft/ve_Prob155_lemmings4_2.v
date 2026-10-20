
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

    parameter WL = 3'b000;
    parameter WR = 3'b001;
    parameter FALLING = 3'b010;
    parameter DIGGING = 3'b011;
    parameter SPLATTED = 3'b100;

    reg [2:0] current_state, next_state;
    reg prev_dir;
 
    reg [4:0] counter;

    assign walk_left = (current_state == WL);
    assign walk_right = (current_state == WR);
    assign aaah = (current_state == FALLING);
    assign digging = (current_state == DIGGING);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WL;
            prev_dir <= 0;
            counter <= 0;
        end else begin
            current_state <= next_state;

            if (current_state == FALLING) begin
                if (next_state == FALLING)
                    counter <= counter + 1;
                else
                    counter <= 0;
            end else
                counter <= 0;

            if (next_state == FALLING) begin
                if (current_state == WL)
                    prev_dir <= 0;
                else if (current_state == WR)
                    prev_dir <= 1;
            end else if (next_state == DIGGING) begin
                if (current_state == WL)
                    prev_dir <= 0;
                else if (current_state == WR)
                    prev_dir <= 1;
            end
        end
    end

    always @(*) begin
        case (current_state)
            WL: begin
                if (!ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_left || bump_right)
                    next_state = WR;
                else
                    next_state = WL;
            end
            WR: begin
                if (!ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_left || bump_right)
                    next_state = WL;
                else
                    next_state = WR;
            end
            FALLING: begin
                if (ground)
                    next_state = (prev_dir) ? WR : WL;
                else if (counter >= 20)
                    next_state = SPLATTED;
                else
                    next_state = FALLING;
            end
            DIGGING: begin
                if (ground)
                    next_state = DIGGING;
                else
                    next_state = FALLING;
            end
            SPLATTED: next_state = SPLATTED;
            default: next_state = WL;
        endcase
    end

endmodule
