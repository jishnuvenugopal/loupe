
module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;
reg [7:0] edge_detect;

always @(posedge clk) begin
    prev_in <= in;
    edge_detect <= ~prev_in & in;
    pedge <= edge_detect;
end

endmodule
