
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge,
    output reg [7:0] out
);

reg [7:0] prev_in;

always @(posedge clk) begin
    prev_in <= in;
end

wire [7:0] edge_detect = (~prev_in & in) & anyedge;

always @(posedge clk) begin
    out <= edge_detect;
end

endmodule
