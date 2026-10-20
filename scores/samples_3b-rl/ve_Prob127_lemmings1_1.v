
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    output reg  walk_left,
    output reg  walk_right
);

    
    reg [1:0] direction;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 2'b00;
 
            walk_left  <= 1'b1;
            walk_right <= 1'b0;
        end else begin
            if (bump_left && bump_right) begin
                
                direction <= direction ^ 2'b11;
            end else if (bump_left) begin
                
                direction <= 2'b01;
                walk_left  <= 1'b0;
                walk_right <= 1'b1;
            end else if (bump_right) begin
                
                direction <= 2'b00;
                walk_left  <= 1'b1;
                walk_right <= 1'b0;
            end else begin
                
                case (direction)
                    2'b00: begin 
                        walk_left  <= 1'b1;
                        walk_right <= 1'b0;
                    end
                    2'b01: begin 
                        walk_left  <= 1'b0;
                        walk_right <= 1'b1;
                    end
                    2'b10: begin 
                        walk_left  <= 1'b1;
                        walk_right <= 1'b0;
                    end
                    2'b11: begin 
                        walk_left  <= 1'b0;
                        walk_right <= 1'b1;
                    end
                endcase
            end
        end
    end

endmodule
