
module TopModule (
    input wire [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    
    assign out_both = {100'b0};
    assign out_any = {100'b0};
    assign out_different = {100'b0};

    
    always @(*) begin
        for (int i = 0;
 i < 100;
 i++) begin
            
            out_both[i] = in[i] && in[i - 1];

            
            out_any[i] = in[i] || in[i + 1];

            
            out_different[i] = in[i] != in[i - 1];
        end
    end

endmodule
