
module clkgenerator (
    input clk,
    input reset,
    output reg led
);

always @(posedge clk) begin
    if (reset) begin
        led <= 0;
    end else begin
        led <= ~led;
    end
end

endmodule
