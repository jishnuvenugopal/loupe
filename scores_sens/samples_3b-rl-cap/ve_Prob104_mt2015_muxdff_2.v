
module full_module (
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (L) begin
        q <= r;
    end else begin
        q <= {q[1] ^ q[2], q[0], q[2]};
    end
end

endmodule

module TopModule (
    input clk,
    input L,
    input q_in,
    input [1:0] r_in,
    output reg Q
);

full_module u1 (
    .clk(clk),
    .L(L),
    .q_in(q_in),
    .r_in(r_in),
    .q(Q)
);

full_module u2 (
    .clk(clk),
    .L(L),
    .q_in(q_in),
    .r_in(r_in),
    .q(Q)
);

full_module u3 (
    .clk(clk),
    .L(L),
    .q_in(q_in),
    .r_in(r_in),
    .q(Q)
);

endmodule
