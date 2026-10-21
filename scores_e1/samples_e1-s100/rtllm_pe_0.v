
module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

reg [31:0] reg_c;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        reg_c <= 0;
    end else begin
        reg_c <= reg_c + (a * b);
    end
end

assign c = reg_c;

endmodule
