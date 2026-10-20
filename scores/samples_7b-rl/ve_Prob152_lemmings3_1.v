
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    
    localparam S_WL = 2'd0,
               S_WR = 2'd1,
               S_FALL = 2'd2,
               S_DIG = 2'd3;

    reg [1:0] state, next_state;
    reg saved_dir;
 

    
    assign walk_left = (state == S_WL);
    assign walk_right = (state == S_WR);
    assign aaah = (state == S_FALL);
    assign digging = (state == S_DIG);

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_WL;
            saved_dir <= 0;
        end else begin
            state <= next_state;
            
            if ((next_state == S_FALL) && (state != S_FALL)) begin
                saved_dir <= (state == S_WL);
            end
        end
    end

    
    always @* begin
        next_state = state;

        
        if (!ground) begin
            next_state = S_FALL;
        end
        else if ((state == S_WL || state == S_WR) && dig) begin
            
            next_state = S_DIG;
        end
        
        else if (state == S_WL && bump_right) begin
            next_state = S_WR;
        end
        else if (state == S_WR && bump_left) begin
            next_state = S_WL;
        end
        
        if (state == S_FALL && ground) begin
            next_state = saved_dir ? S_WR : S_WL;
        end
        
        if (state == S_DIG && !ground) begin
            next_state = S_FALL;
        end
    end

endmodule
