
module TopModule (
    input        clk,
    input        areset,
    input        bump_left,
    input        bump_right,
    input        ground,
    input        dig,
    output reg   walk_left,
    output reg   walk_right,
    output reg   aaah,
    output reg   digging
);

    
    reg [1:0] state;

    
    
    
    

    
    initial begin
        state = 2'b01;
 
        walk_left = 1'b1;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
 
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end else begin
            
            if (!ground) begin
                aaah <= 1'b1;
                state <= 2'b00;
 
            end
            
            else if (dig && ground) begin
                digging <= 1'b1;
                state <= 2'b00;
 
            end
            
            else begin
                
                if (bump_left && bump_right) begin
                    if (state == 2'b01) begin
                        state <= 2'b10;
 
                    end else begin
                        state <= 2'b01;
 
                    end
                end
                
                else if (bump_left) begin
                    state <= 2'b10;
 
                end
                
                else if (bump_right) begin
                    state <= 2'b01;
 
                end
                
                else begin
                    if (state == 2'b01) begin
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else begin
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end
                end
                
                digging <= 1'b0;
                aaah <= 1'b0;
            end
        end
    end

endmodule
