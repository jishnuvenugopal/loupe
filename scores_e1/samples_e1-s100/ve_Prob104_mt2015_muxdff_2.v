

module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    
    reg [2:0] q;

    
    reg [1:0] mux_out;

    
    always @(posedge clk) begin
        if (L) begin
            q <= r_in;
        end else begin
            mux_out <= {q_in[1] ^ q_in[2], q_in[0], q_in[2]};
        end
    end

    
    assign Q = mux_out;

endmodule


module main (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    
    TopModule top1 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .Q(Q[0])
    );

    TopModule top2 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .Q(Q[1])
    );

    TopModule top3 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .Q(Q[2])
    );

endmodule
