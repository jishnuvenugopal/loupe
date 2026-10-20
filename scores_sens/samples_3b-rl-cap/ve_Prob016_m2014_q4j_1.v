
module TopModule (
    input [3:0] x,
    input [3:0] y,
    output reg [4:0] sum
);

    wire [4:0] sum_wire;
    wire carry_in = 1'b0;

    assign sum_wire = x + y + carry_in;
    assign sum = sum_wire;

endmodule
