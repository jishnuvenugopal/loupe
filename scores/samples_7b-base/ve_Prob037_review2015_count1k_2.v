
module TopModule(input clk, input reset, output reg [9:0] q);

reg [9:0] counter;

always @(posedge clk) begin
    if (reset)
        counter <= 10'b0000000000;
    else
        counter <= counter + 1;
end

assign q = counter;

endmodule
