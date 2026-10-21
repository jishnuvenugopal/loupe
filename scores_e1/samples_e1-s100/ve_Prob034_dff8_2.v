
module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    
    reg [7:0] dffs[7:0];

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 8;
 i++) begin
            if (i == 0) begin
                dffs[i] <= d;
            end else begin
                dffs[i] <= dffs[i-1];
            end
        end
    end

    
    assign q = dffs[7];

endmodule
