
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge,
    output [7:0] out
);

reg [7:0] prev_in;


wire [7:0] edge_0_1 = (~prev_in) & in;


wire [7:0] edge_0_1_masked = edge_0_1 & anyedge;

reg [7:0] out_reg;

always @(posedge clk) begin
    prev_in <= in;
    out_reg <= edge_0_1_masked;
end

assign out = out_reg;

endmodule
