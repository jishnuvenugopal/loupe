
module TopModule (
    input wire clk,
    input wire areset,
    input wire bump_left,
    input wire bump_right,
    input wire ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    
    typedef enum {LEFT, RIGHT} State;

    
    State current_state = LEFT;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= LEFT;
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end else begin
            case (current_state)
                LEFT: begin
                    if (bump_left) begin
                        current_state <= RIGHT;
                    end else if (bump_right) begin
                        current_state <= LEFT;
                    end else if (ground == 0) begin
                        current_state <= LEFT;
                        aaah <= 1'b1;
                    end else if (ground == 1) begin
                        current_state <= LEFT;
                        aaah <= 1'b0;
                    end
                end
                RIGHT: begin
                    if (bump_left) begin
                        current_state <= LEFT;
                    end else if (bump_right) begin
                        current_state <= RIGHT;
                    end else if (ground == 0) begin
                        current_state <= RIGHT;
                        aaah <= 1'b1;
                    end else if (ground == 1) begin
                        current_state <= RIGHT;
                        aaah <= 1'b0;
                    end
                end
            endcase
            walk_left <= (current_state == LEFT);
            walk_right <= (current_state == RIGHT);
        end
    end

endmodule
