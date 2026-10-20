
module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] in_reg;
wire [7:0] edge_detect;

assign edge_detect = in & ~in_reg;

reg [7:0] pedge_reg;

always @(posedge clk) begin
    in_reg <= in;
    pedge_reg <= edge_detect;
end

assign pedge = pedge_reg;

endmodule
