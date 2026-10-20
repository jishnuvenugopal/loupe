
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    reg direction;
 
    reg is_falling;
 
    reg fallback_dir;
 

    assign walk_left  = direction & ~is_falling;
    assign walk_right = ~direction & ~is_falling;
    assign aaah = is_falling;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b1;
 
            is_falling <= 1'b0;
            fallback_dir <= 1'b1;
        end else begin
            if (is_falling) begin
                
                if (ground) begin
                    is_falling <= 1'b0;
                    direction <= fallback_dir;
                end
            end else begin
                if (ground == 1'b0) begin
                    
                    is_falling <= 1'b1;
                    fallback_dir <= direction;
                end else begin
                    
                    if (bump_left || bump_right) begin
                        direction <= ~direction;
                    end
                end
            end
        end
    end
endmodule
