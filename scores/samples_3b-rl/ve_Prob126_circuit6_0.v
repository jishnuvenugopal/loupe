
module TopModule (
    input  wire        clk,
    input  wire        rst,
    input  wire [2:0]  a,
    output reg  [15:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 16'b0;
    end else begin
        q <= a;
    end
end


assign a = 3'b000;

endmodule
