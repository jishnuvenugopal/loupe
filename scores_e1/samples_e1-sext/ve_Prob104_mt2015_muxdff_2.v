
module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg [2:0] Q
);

    
    full_module ff (
        .r(r_in),
        .L(L),
        .clk(clk),
        .q(Q)
    );

    
    full_module mux (
        .r(r_in),
        .L(L),
        .clk(clk),
        .q(Q)
    );

endmodule
