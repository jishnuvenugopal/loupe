

module flipflop (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg q
);

always @(posedge clk) begin
    if (L) begin
        q <= r_in;
    end else begin
        q <= {q[1] ^ q[2], q[0], q[2]};
    end
end

endmodule


module mux21 (
    input [1:0] sel,
    input [2:0] a,
    input [2:0] b,
    output reg y
);

always @(posedge sel) begin
    case (sel)
        2'b00: y <= a;
        2'b01: y <= b;
        2'b10: y <= a;
        2'b11: y <= b;
    endcase
end

endmodule


module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg [2:0] Q
);


flipflop ff1 (
    .clk(clk),
    .L(L),
    .q_in(q_in),
    .r_in(r_in),
    .q(Q[0])
);

flipflop ff2 (
    .clk(clk),
    .L(L),
    .q_in(q_in),
    .r_in(r_in),
    .q(Q[1])
);

flipflop ff3 (
    .clk(clk),
    .L(L),
    .q_in(q_in),
    .r_in(r_in),
    .q(Q[2])
);


mux21 mux1 (
    .sel(2'b00),
    .a(Q[0]),
    .b(Q[1]),
    .y(Q[0])
);

mux21 mux2 (
    .sel(2'b01),
    .a(Q[0]),
    .b(Q[2]),
    .y(Q[1])
);

mux21 mux3 (
    .sel(2'b10),
    .a(Q[1]),
    .b(Q[2]),
    .y(Q[2])
);

endmodule


module top (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg [2:0] Q
);

TopModule top_module (
    .clk(clk),
    .L(L),
    .q_in(q_in),
    .r_in(r_in),
    .Q(Q)
);

endmodule
