
module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    
    full_module flipflop1 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .Q(Q[0])
    );

    full_module flipflop2 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .Q(Q[1])
    );

    full_module flipflop3 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .Q(Q[2])
    );

    
    two_one_multiplexer mux (
        .A(Q[0]),
        .B(Q[1]),
        .S(L),
        .Y(Q[2])
    );

endmodule
