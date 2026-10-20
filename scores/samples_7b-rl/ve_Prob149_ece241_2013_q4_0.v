
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


always @(posedge clk) begin
    if (reset) begin
        
        fr0 <= 1;
        fr1 <= 1;
        fr2 <= 1;
        dfr <= 1;
        prev_s <= 3'b000;
    end
    else begin
        
        prev_s <= s;
        
        
        fr0 <= 0;
        fr1 <= 0;
        fr2 <= 0;
        dfr <= 0;
        
        
        case (s)
            3'b111: begin 
                
                ;
 
            end
            3'b110: begin 
                fr0 <= 1;
                dfr <= (prev_s < s);
 
            end
            3'b100: begin 
                fr0 <= 1;
                fr1 <= 1;
                dfr <= (prev_s < s);
 
            end
            3'b001: begin 
                fr0 <= 1;
                fr1 <= 1;
                fr2 <= 1;
            end
            default: begin 
                ;
 
            end
        endcase
    end
end

endmodule
