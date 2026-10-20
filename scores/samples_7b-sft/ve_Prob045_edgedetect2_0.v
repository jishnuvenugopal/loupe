
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge,
    output [7:0] out
);

reg [7:0] prev_in;
reg [7:0] edge_reg;
reg [7:0] out_reg;

always @(posedge clk) begin
    prev_in <= in;
    edge_reg <= (~prev_in & in);
    out_reg <= edge_reg;
end

assign out = out_reg;

endmodule
