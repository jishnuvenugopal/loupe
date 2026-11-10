
module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg [2:0] Q
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

endmodule
