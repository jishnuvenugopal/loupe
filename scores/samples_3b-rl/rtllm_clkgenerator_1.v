
module clkgenerator (
    input clk,
    input rst,
    output reg clk_out
);

parameter PERIOD = 10;

reg [1:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 2'b00;
        clk_out <= 1'b0;
    end else begin
        counter <= counter + 1;
        if (counter == PERIOD/2) begin
            clk_out <= ~clk_out;
            counter <= 2'b00;
        end
    end
end

endmodule
