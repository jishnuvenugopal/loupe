
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

    
    reg [1:0] state;

    
    
    
    

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;
 
        else begin
            
            if (!ground) begin
                aaah <= 1'b1;
                state <= 2'b00;
 
            end
            
            else if (dig) begin
                digging <= 1'b1;
            end
            
            else begin
                
                if (bump_left && bump_right) begin
                    state <= ~state;
                end
                
                else if (bump_left) begin
                    state <= 2'b10;
 
                end
                
                else if (bump_right) begin
                    state <= 2'b01;
 
                end
                
                
            end
        end
    end

    
    always @(*) begin
        case (state)
            2'b00: 
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            2'b01: 
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            2'b10: 
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
                digging = 1'b0;
        endcase
    end

endmodule
