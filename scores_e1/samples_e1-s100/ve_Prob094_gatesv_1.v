
module TopModule (
    input wire [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

always @(*) begin
    
    out_both = 4'b0000;
    out_any = 4'b0000;
    out_different = 4'b0000;

    
    for (int i = 0;
 i < 4;
 i++) begin
        
        if (in[i] == 1 && in[i + 1] == 1) begin
            out_both[i] = 1'b1;
        end else begin
            out_both[i] = 1'b0;
        end

        
        if (in[i] == 1 || in[i + 1] == 1) begin
            out_any[i] = 1'b1;
        end else begin
            out_any[i] = 1'b0;
        end

        
        if (in[i] != in[i + 1]) begin
            out_different[i] = 1'b1;
        end else begin
            out_different[i] = 1'b0;
        end
    end
end

endmodule
