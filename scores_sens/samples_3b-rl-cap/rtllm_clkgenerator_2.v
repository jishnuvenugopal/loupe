
module clkgenerator (
    input clk,
    input rst,
    output reg clk
);

    parameter PERIOD = 10;

    reg [31:0] counter;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            clk <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == (PERIOD/2)-1) begin
                clk <= ~clk;
                counter <= 0;
            end
        end
    end

endmodule
