
module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        prev_in <= in;
        edge_detected <= in & ~prev_in;
    end

    assign pedge = edge_detected;

endmodule
