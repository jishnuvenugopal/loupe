
module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);


full_module #(.WIDTH(3)) full_module_1 (
    .r({q_in, r_in}),
    .L(L),
    .clk(clk),
    .q(q_1)
);

full_module #(.WIDTH(3)) full_module_2 (
    .r({q_1[1], q_1[2], q_1[0]}),
    .L(L),
    .clk(clk),
    .q(q_2)
);

full_module #(.WIDTH(3)) full_module_3 (
    .r({q_2[1], q_2[2], q_2[0]}),
    .L(L),
    .clk(clk),
    .q(Q)
);

endmodule


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
