
module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (a == 1'b1) begin
            counter <= counter + 1'b1;
        end
        q <= counter;
    end

endmodule
