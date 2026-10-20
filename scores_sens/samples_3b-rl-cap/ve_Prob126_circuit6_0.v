
module TopModule (
    input  wire        clk,
    input  wire        rst,
    input  wire [2:0]  a,
    output reg  [15:0] q
);

always @(posedge clk) begin
    if (rst)
        q <= 16'b0;
    else
        q <= a;
end



endmodule
