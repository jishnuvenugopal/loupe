
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
    input r_in,
    output Q
);

    wire Q1, Q2, Q3;
    full_module u1 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .q(Q1)
    );
    full_module u2 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .q(Q2)
    );
    full_module u3 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .q(Q3)
    );

    assign Q = Q1 ^ Q2 ^ Q3;

endmodule
