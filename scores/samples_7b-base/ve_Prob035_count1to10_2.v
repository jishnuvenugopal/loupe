
module TopModule (
    input wire clk,
    input wire reset,
    output reg [3:0] q
);

reg [3:0] counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 4'd1;
    end else begin
        counter <= counter + 1;
        if (counter == 4'd10) begin
            counter <= 4'd1;
        end
    end
end

assign q = counter;

endmodule
