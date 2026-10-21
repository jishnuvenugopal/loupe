
module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    
    reg [7:0] dffs[7:0];

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 8;
 i = i + 1) begin
            if (dffs[i] == 1'b0) begin
                dffs[i] <= d[i];
            end
        end
    end

    
    assign q = dffs;

endmodule
