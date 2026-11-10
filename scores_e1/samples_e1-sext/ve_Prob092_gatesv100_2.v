
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
        
        if (i == 0) begin
            out_different[i] = in[i] ^ in[99];
        end else begin
            out_different[i] = in[i] ^ in[i-1];
        end

        
        if (i == 0) begin
            out_both[i] = in[i] & in[99];
        end else begin
            out_both[i] = in[i] & in[i-1];
        end

        
        if (i == 99) begin
            out_any[i] = in[i] | in[0];
        end else begin
            out_any[i] = in[i] | in[i+1];
        end
    end
end

endmodule
