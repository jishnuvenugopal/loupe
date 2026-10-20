
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output reg  walk_left,
    output reg  walk_right,
    output reg  aaah
);

    
    typedef enum {walking_left, walking_right} state_t;
    state_t state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= walking_left;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end else begin
            case (state)
                walking_left: begin
                    if (ground) begin
                        if (bump_right) begin
                            state <= walking_right;
                            walk_left <= 1'b0;
                            walk_right <= 1'b1;
                        end else begin
                            walk_left <= 1'b1;
                            walk_right <= 1'b0;
                            aaah <= 1'b0;
                        end
                    end else begin
                        aaah <= 1'b1;
                    end
                end
                walking_right: begin
                    if (ground) begin
                        if (bump_left) begin
                            state <= walking_left;
                            walk_left <= 1'b1;
                            walk_right <= 1'b0;
                        end else begin
                            walk_left <= 1'b0;
                            walk_right <= 1'b1;
                            aaah <= 1'b0;
                        end
                    end else begin
                        aaah <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule
