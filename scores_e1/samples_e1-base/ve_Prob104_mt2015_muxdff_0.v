
module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    
    flipflop ff1 (
        .clk(clk),
        .L(L),
        .q(q_in),
        .q_out(q[0])
    );

    flipflop ff2 (
        .clk(clk),
        .L(L),
        .q(q_in),
        .q_out(q[1])
    );

    flipflop ff3 (
        .clk(clk),
        .L(L),
        .q(q_in),
        .q_out(q[2])
    );

    
    mux2_1 mux (
        .clk(clk),
        .L(L),
        .in1(ff1.q_out),
        .in2(ff2.q_out),
        .out(Q)
    );

endmodule

module flipflop (
    input  clk,
    input  L,
    input  q,
    output reg q_out
);

    always @(posedge clk) begin
        if (L) begin
            q_out <= q;
        end else begin
            q_out <= {q[1] ^ q[2], q[0], q[2]};
        end
    end

endmodule

module mux2_1 (
    input  clk,
    input  L,
    input  in1,
    input  in2,
    output reg out
);

    always @(posedge clk) begin
        if (L) begin
            out <= in1;
        end else begin
            out <= in2;
        end
    end

endmodule
