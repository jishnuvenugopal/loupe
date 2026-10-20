
module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

reg [31:0] count;

always @(posedge count) begin
    clk <= ~clk;
end

always @(posedge clk or posedge reset) begin
    if (reset)
        count <= 0;
    else if (count == PERIOD - 1)
        count <= 0;
    else
        count <= count + 1;
end

endmodule
