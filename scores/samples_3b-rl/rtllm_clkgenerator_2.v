
module clkgenerator (
    input clk,
    input rst,
    output reg clk
);

parameter PERIOD = 10;

reg [31:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        clk <= 0;
    end else begin
        count <= count + 1;
        if (count == PERIOD-1) begin
            count <= 0;
            clk <= ~clk;
        end
    end
end

endmodule
