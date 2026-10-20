
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output reg  walk_left,
    output reg  walk_right,
    output reg  aaah,
    output reg  digging
);

    
    reg [0:0] state;

    always @(posedge clk) begin
        if (areset) begin
            state <= 1'b0;
 
        end else begin
            
            if (!ground) begin
                aaah <= 1'b1;
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                digging <= 1'b0;
            end else begin
                
                if (dig && ground) begin
                    digging <= 1'b1;
                    aaah <= 1'b0;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                end else begin
                    digging <= 1'b0;
                    aaah <= 1'b0;
                    
                    if (bump_left) begin
                        state <= 1'b1;
 
                    end else if (bump_right) begin
                        state <= 1'b0;
 
                    end
                    
                    if (state == 1'b0) begin
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else begin
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end
                end
            end
        end
    end

endmodule
