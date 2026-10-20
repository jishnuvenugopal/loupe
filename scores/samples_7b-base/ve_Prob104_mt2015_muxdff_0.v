
module main_module (
    input clk,
    input [2:0] q_in,
    input [2:0] r_in,
    input [2:0] L,
    output [2:0] Q
);

    wire [2:0] q_out;
    wire [2:0] Q_out;

    
    top_module top1 (
        .clk(clk),
        .q_in(q_in[0]),
        .r_in(r_in[0]),
        .L(L[0]),
        .Q(q_out[0])
    );

    top_module top2 (
        .clk(clk),
        .q_in(q_out[0]),
        .r_in(r_in[1]),
        .L(L[1]),
        .Q(q_out[1])
    );

    top_module top3 (
        .clk(clk),
        .q_in(q_out[1]),
        .r_in(r_in[2]),
        .L(L[2]),
        .Q(q_out[2])
    );

    
    assign Q = Q_out;

endmodule
