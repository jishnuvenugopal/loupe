
module TopModule #(
    parameter BIT = 0
) (
    input clk,
    input L,
    input r_in,
    input [2:0] others,
    output Q
);

reg Q_reg;
wire Q_next;

assign Q_next = L ? r_in : 
                (BIT == 2) ? (others[1] ^ others[2]) :
                (BIT == 1) ? others[0] :
                others[2];

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule

module full_module (
    input clk,
    input L,
    input [2:0] r,
    output [2:0] q
);

TopModule #(.BIT(2)) tm2 (
    .clk(clk),
    .L(L),
    .r_in(r[2]),
    .others({q[1], q[0], q[2]}),
    .Q(q[2])
);

TopModule #(.BIT(1)) tm1 (
    .clk(clk),
    .L(L),
    .r_in(r[1]),
    .others({q[0], q[2], q[1]}),
    .Q(q[1])
);

TopModule #(.BIT(0)) tm0 (
    .clk(clk),
    .L(L),
    .r_in(r[0]),
    .others({q[2], q[1], q[0]}),
    .Q(q[0])
);

endmodule
