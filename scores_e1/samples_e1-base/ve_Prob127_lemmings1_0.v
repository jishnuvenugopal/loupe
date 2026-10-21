
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    
    typedef enum {left, right} state_t;

    
    state_t state;

    
    always @(posedge clk or posedge areset) begin
        if (arst) begin
            state <= left;
        end else begin
            case (state)
                left: begin
                    if (bump_left) begin
                        state <= right;
                    end else if (bump_right) begin
                        state <= left;
                    end else begin
                        state <= left;
                    end
                end
                right: begin
                    if (bump_left) begin
                        state <= left;
                    end else if (bump_right) begin
                        state <= right;
                    end else begin
                        state <= right;
                    end
                end
            endcase
        end
    end

    
    always @(*) begin
        if (state == left) begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end else if (state == right) begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
        end
    end

endmodule
