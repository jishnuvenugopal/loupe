
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
        end else begin
            counter <= counter + 1'b1;
        end
    end

    assign q = counter;

endmodule
