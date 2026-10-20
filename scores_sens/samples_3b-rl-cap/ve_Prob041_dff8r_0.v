
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    
    reg [7:0] q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b0;
        end else begin
            for (integer i = 0;
 i < 8;
 i = i + 1) begin
                q[i] <= d[i];
            end
        end
    end

endmodule
