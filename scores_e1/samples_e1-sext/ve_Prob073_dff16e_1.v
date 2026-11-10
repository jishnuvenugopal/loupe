
module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    
    reg [15:0] dffs [0:15];

    
    reg clk_en;

    
    reg reset;

    
    assign reset = ~resetn;

    
    assign clk_en = clk && ~reset;

    
    always @(posedge clk_en) begin
        for (int i = 0;
 i < 16;
 i++) begin
            if (byteena[i] == 1) begin
                dffs[i] <= d;
            end
        end
    end

    
    assign q = dffs;

endmodule
