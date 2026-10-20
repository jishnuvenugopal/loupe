
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire slowena,
    output reg  [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else if (slowena) begin
        if (q < 4'b1000) begin
            q <= q + 1;
        end
    end
end




endmodule
