
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

    
    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state   <= 2'b00;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end else begin
            
            if (ground) begin
                
            end else begin
                
                aaah <= 1'b1;
                
                if (bump_left && bump_right) begin
                    state <= ~state;
                end
                
                else if (bump_left) begin
                    state <= 2'b01;
                end
                
                else if (bump_right) begin
                    state <= 2'b00;
                end
                
            end
            
            walk_left <= (state == 2'b00);
            walk_right <= (state == 2'b01);
        end
    end

endmodule
