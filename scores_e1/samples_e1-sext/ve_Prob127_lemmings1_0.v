
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left
);

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin
                    if (bump_left) begin
                        state <= 2'b01;
                    end else if (bump_right) begin
                        state <= 2'b10;
                    end else begin
                        state <= 2'b00;
                    end
                end
                2'b01: begin
                    state <= 2'b10;
                end
                2'b10: begin
                    state <= 2'b01;
                end
            endcase
        end
    end

    assign walk_left = state == 2'b01;

endmodule
