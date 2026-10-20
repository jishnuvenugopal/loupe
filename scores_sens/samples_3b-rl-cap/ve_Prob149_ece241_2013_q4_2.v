
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    
    reg [2:0] prev_s;
    reg [1:0] prev_level;
    reg [1:0] current_level;

    
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b0;
            prev_level <= 2'b0;
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else begin
            
            
            

            
            if (s[2])
                prev_level <= 2'b11;
 
            else if (s[0])
                prev_level <= 2'b01;
 
            else if (s[1])
                prev_level <= 2'b00;
 
            else
                prev_level <= 2'b10;
 

            
            if (s[2])
                current_level <= 2'b11;
 
            else if (s[0])
                current_level <= 2'b01;
 
            else if (s[1])
                current_level <= 2'b00;
 
            else
                current_level <= 2'b10;
 

            
            if (s[2])
                fr2 <= 1'b0;
            else if (s[0])
                fr2 <= 1'b1;
            else
                fr2 <= 1'b0;

            if (s[2])
                fr1 <= 1'b0;
            else if (s[0])
                fr1 <= 1'b1;
            else
                fr1 <= 1'b0;

            if (s[2])
                fr0 <= 1'b0;
            else if (s[0])
                fr0 <= 1'b1;
            else
                fr0 <= 1'b0;

            
            if (prev_level < current_level)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;

            
            prev_s <= s;
        end
    end

endmodule
