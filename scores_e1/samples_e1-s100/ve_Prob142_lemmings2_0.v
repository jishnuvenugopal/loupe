
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    
    reg [1:0] state;
    reg [1:0] prev_state;
    reg [1:0] fall_count;

    
    reg [3:0] fall_counter;

    
    initial begin
        state = WL;
        prev_state = WL;
        fall_count = 0;
        fall_counter = 0;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
            prev_state <= WL;
            fall_count <= 0;
            fall_counter <= 0;
        end else begin
            prev_state <= state;
            case (state)
                WL: begin
                    if (bump_left) begin
                        state <= WR;
                    end else if (bump_right) begin
                        state <= FL;
                    end else if (ground) begin
                        state <= WL;
                    end else begin
                        state <= WL;
                    end
                end
                WR: begin
                    if (bump_left) begin
                        state <= FL;
                    end else if (bump_right) begin
                        state <= WL;
                    end else if (ground) begin
                        state <= WR;
                    end else begin
                        state <= WR;
                    end
                end
                FL: begin
                    if (bump_left) begin
                        state <= WL;
                    end else if (bump_right) begin
                        state <= WR;
                    end else if (ground) begin
                        state <= FL;
                    end else begin
                        state <= WL;
                    end
                end
            endcase

            
            if (state == FL) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end

            
            case (state)
                WL: begin
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                end
                WR: begin
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                end
                FL: begin
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 1;
                end
            endcase
        end
    end

endmodule
