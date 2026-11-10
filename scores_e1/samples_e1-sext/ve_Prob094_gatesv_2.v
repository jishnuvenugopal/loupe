
module TopModule (
    input wire [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

always @(*) begin
    
    for (int i = 0;
 i < 4;
 i++) begin
        out_both[i] = (in[i] && in[i + 1]) ? 1'b1 : 1'b0;
    end

    
    for (int i = 0;
 i < 4;
 i++) begin
        out_any[i] = (in[i] || in[i + 1]) ? 1'b1 : 1'b0;
    end

    
    for (int i = 0;
 i < 4;
 i++) begin
        out_different[i] = (in[i] != in[i + 1]) ? 1'b1 : 1'b0;
    end
end

endmodule
