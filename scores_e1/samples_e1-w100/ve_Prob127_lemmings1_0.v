
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left
);

    
    typedef enum {left, right} state_t;

    
    reg state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= left;
        end else begin
            state <= state;
        end
    end

    
    always @(posedge clk) begin
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

    
    assign walk_left = (state == left);

endmodule
