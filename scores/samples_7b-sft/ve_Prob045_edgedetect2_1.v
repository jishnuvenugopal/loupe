
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge, 
    output [7:0] out
);

reg [7:0] prev_in;
reg [7:0] edge_detected_reg;

always @(posedge clk) begin
    prev_in <= in;
    edge_detected_reg <= (~prev_in) & in;
 
end

assign out = edge_detected_reg;

endmodule
