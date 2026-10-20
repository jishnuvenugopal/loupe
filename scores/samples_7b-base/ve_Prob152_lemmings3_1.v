
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
    
    typedef enum reg [2:0] {
        WL = 3'b000,
        WR = 3'b001,
        F  = 3'b010
    } State, NextState;

    
    State state, next_state;
    reg [1:0] dig_count;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
            dig_count <= 2'b00;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end else begin
            state <= next_state;
            walk_left <= (state == WL) ? 1'b1 : 1'b0;
            walk_right <= (state == WR) ? 1'b1 : 1'b0;
            aaah <= (state == F) ? 1'b1 : 1'b0;
            digging <= (state == WL || state == WR) && (ground == 1'b1) && (dig_count != 2'b10);

            if (dig && (ground == 1'b1)) begin
                if (state == WL) begin
                    dig_count <= dig_count + 1;
                end else if (state == WR) begin
                    dig_count <= dig_count + 1;
                end
            end else begin
                dig_count <= 2'b00;
            end
        end
    end

    
    always @(*) begin
        next_state = state;
        case (state)
            WL: begin
                if (bump_left) begin
                    next_state = WR;
                end else if (bump_right) begin
                    next_state = WL;
                end else if (!ground) begin
                    next_state = F;
                end
            end
            WR: begin
                if (bump_left) begin
                    next_state = WL;
                end else if (bump_right) begin
                    next_state = WR;
                end else if (!ground) begin
                    next_state = F;
                end
            end
            F: begin
                if (ground) begin
                    if (state == WL) begin
                        next_state = WL;
                    end else if (state == WR) begin
                        next_state = WR;
                    end
                end
            end
        endcase
    end
endmodule
