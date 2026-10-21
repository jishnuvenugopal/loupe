
module top (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    TopModule top1 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .Q(Q)
    );

    TopModule top2 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .Q(Q)
    );

    TopModule top3 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .Q(Q)
    );

endmodule
