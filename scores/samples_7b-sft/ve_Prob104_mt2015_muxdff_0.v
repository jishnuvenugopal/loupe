
module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

wire computed_value;






assign computed_value = L ? r_in : ( (Q == 2) ? (q1 ^ q2) : ( (Q == 1) ? q1 : q2 ) );

always @(posedge clk) begin
    Q <= computed_value;
end

endmodule


module full_module (
    input [2:0] r,
    input L,
    input clk,
    output [2:0] q
);

TopModule #(.BIT(2)) bit2 (.clk(clk), .L(L), .r_in(r[2]), .q_in(q[2]), .Q(q[2]));
TopModule #(.BIT(1)) bit1 (.clk(clk), .L(L), .r_in(r[1]), .q_in(q[1]), .Q(q[1]));
TopModule #(.BIT(0)) bit0 (.clk(clk), .L(L), .r_in(r[0]), .q_in(q[0]), .Q(q[0]));

endmodule
