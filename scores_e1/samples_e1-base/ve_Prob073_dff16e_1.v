
module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    
    reg [15:0] dffs [0:15];

    
    reg clk_en;

    
    reg rst;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            rst <= 1'b1;
            clk_en <= 1'b0;
        end else begin
            rst <= 1'b0;
            clk_en <= 1'b1;
        end
    end

    
    always @(posedge clk) begin
        if (clk_en) begin
            for (int i = 0;
 i < 16;
 i++) begin
                if (byteena[1] && i == 15) begin
                    dffs[i] <= d[15:8];
                end else if (byteena[0] && i == 0) begin
                    dffs[i] <= d[7:0];
                end else begin
                    dffs[i] <= dffs[i];
                end
            end
        end
    end

    
    assign q = dffs;

endmodule
