
module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    
    reg [7:0] d_ff [0:7];

    
    assign d_ff[0] = d;

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 7;
 i = i + 1) begin
            d_ff[i + 1] = d_ff[i];
        end
    end

    
    assign q = d_ff[7];

endmodule
