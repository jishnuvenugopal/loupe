
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    output reg  walk_left,
    output reg  walk_right
);

    
    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end else begin
            case (state)
                2'b00: begin 
                    if (bump_left || bump_right) begin
                        state <= 2'b01;
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end else begin
                        state <= 2'b00;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end
                end
                2'b01: begin 
                    if (bump_left || bump_right) begin
                        state <= 2'b00;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else begin
                        state <= 2'b01;
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end
                end
                default: begin
                    state <= 2'b00;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end
            endcase
        end
    end

    
    assign walk_left = (state == 2'b00) || (bump_left && bump_right);
    assign walk_right = (state == 2'b01) && (bump_left || bump_right);

endmodule
