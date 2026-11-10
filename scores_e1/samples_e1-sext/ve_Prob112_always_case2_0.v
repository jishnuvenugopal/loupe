
module TopModule (
    input  [3:0] in,
    output reg [1:0] pos,
    output reg [3:0] out
);

always @(*) begin
    
    if (in == 4'b0000) begin
        pos = 2'b00;
        out = 4'b0000;
    end else begin
        
        pos = 2'b00;
        for (int i = 0;
 i < 4;
 i++) begin
            if (in[i] == 1'b1) begin
                pos = 2'b00 + i;
                break;
            end
        end
        
        out = in;
    end
end

endmodule
