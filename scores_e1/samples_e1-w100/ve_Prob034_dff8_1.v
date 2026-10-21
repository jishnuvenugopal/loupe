
module TopModule (
    input  clk,
    input  d   (8 bits),
    output q   (8 bits)
);

    
    reg [7:0] dff [0:7];

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 8;
 i = i + 1) begin
            dff[i] <= d[i];
        end
    end

    
    assign q = dff[0];

endmodule
