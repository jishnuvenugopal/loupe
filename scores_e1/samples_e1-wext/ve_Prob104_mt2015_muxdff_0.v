
module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg [2:0] Q
);

    
    flipflop ff1 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .q(Q[0])
    );

    flipflop ff2 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .q(Q[1])
    );

    flipflop ff3 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .q(Q[2])
    );

    
    mux2_1 mux (
        .clk(clk),
        .L(L),
        .q_in1(Q[0]),
        .q_in2(Q[1]),
        .q_out(Q[2])
    );

endmodule

module flipflop (
    input  clk,
    input  L,
    input  q_in,
    output reg q
);

    always @(posedge clk) begin
        if (L) begin
            q <= q_in;
        end else begin
            q <= {q[1] ^ q[2], q[0], q[2]};
        end
    end

endmodule

module mux2_1 (
    input  clk,
    input  L,
    input  q_in1,
    input  q_in2,
    output reg q_out
);

    always @(posedge clk) begin
        if (L) begin
            q_out <= q_in1;
        end else begin
            q_out <= q_in2;
        end
    end

endmodule
