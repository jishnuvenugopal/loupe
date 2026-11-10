
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left
);

    
    typedef enum {WalkingLeft, WalkingRight} State;

    
    reg [1:0] state;

    
    always @(posedge areset) begin
        state <= WalkingLeft;
    end

    
    always @(posedge clk) begin
        case (state)
            WalkingLeft: begin
                if (bump_left) begin
                    state <= WalkingRight;
                end else if (bump_right) begin
                    state <= WalkingLeft;
                end else begin
                    state <= WalkingLeft;
                end
            end
            WalkingRight: begin
                if (bump_left) begin
                    state <= WalkingLeft;
                end else if (bump_right) begin
                    state <= WalkingRight;
                end else begin
                    state <= WalkingRight;
                end
            end
        endcase
    end

    
    assign walk_left = state == WalkingLeft;

endmodule
