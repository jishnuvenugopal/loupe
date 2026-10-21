
module TopModule (
    input wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    
    assign out_both = {99'b0, in[99]};
 
    assign out_any = {99'b0, in[0]};
 
    assign out_different = {99'b0, in[0]};
 

    
    always @(*) begin
        for (int i = 0;
 i < 99;
 i++) begin
            if (in[i] && in[i + 1]) begin
                out_both[i] = 1'b1;
            else begin
                out_both[i] = 1'b0;
            end
        end
    end

    
    always @(*) begin
        for (int i = 0;
 i < 99;
 i++) begin
            if (in[i] || in[i + 1]) begin
                out_any[i] = 1'b1;
            else begin
                out_any[i] = 1'b0;
            end
        end
    end

    
    always @(*) begin
        for (int i = 0;
 i < 99;
 i++) begin
            if (in[i] != in[i + 1]) begin
                out_different[i] = 1'b1;
            else begin
                out_different[i] = 1'b0;
            end
        end
    end

endmodule
