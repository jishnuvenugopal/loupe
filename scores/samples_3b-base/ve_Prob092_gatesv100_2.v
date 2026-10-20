
module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    
    assign out_both = 100'b0;
    assign out_any = 100'b0;
    assign out_different = 100'b0;

    
    for (genvar i = 0;
 i < 100;
 i++) begin
        
        if (i > 0 && in[i] == 1 && in[i - 1] == 1) begin
            out_both[i] = 1;
        end

        
        if (i < 99 && in[i] == 1 && in[i + 1] == 1) begin
            out_both[i] = 1;
        end

        
        if (i > 0 && in[i] != in[i - 1]) begin
            out_different[i] = 1;
        end

        
        if (i < 99 && in[i] != in[i + 1]) begin
            out_different[i] = 1;
        end

        
        if (i > 0 && (in[i] == 1 || in[i] == 0) && in[i - 1] == 1) begin
            out_any[i] = 1;
        end

        
        if (i < 99 && (in[i] == 1 || in[i] == 0) && in[i + 1] == 1) begin
            out_any[i] = 1;
        end
    end

endmodule
