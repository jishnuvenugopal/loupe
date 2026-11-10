
module TopModule (
    input wire [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

always @(*) begin
    
    out_both = 100'b0;
    out_any = 100'b0;
    out_different = 100'b0;

    
    for (int i = 0;
 i < 100;
 i++) begin
        
        if (in[i] == 1 && in[i-1] == 1) begin
            out_both[i] = 1;
        end

        
        if (in[i] == 1 || in[(i+1) % 100] == 1) begin
            out_any[i] = 1;
        end

        
        if (in[i] != in[i-1]) begin
            out_different[i] = 1;
        end
    end
end

endmodule
