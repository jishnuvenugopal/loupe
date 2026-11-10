
module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg [2:0] Q
);

    
    flipflop ff (
        .clk(clk),
        .L(L),
        .q(q)
    );

    
    mux2_1 mux (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .q(Q)
    );

endmodule

module flipflop (
    input  clk,
    input  L,
    output reg q
);

    always @(posedge clk) begin
        if (L) begin
            q <= 1'b1;
        end else begin
            q <= 1'b0;
        end
    end

endmodule

module mux2_1 (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg q
);

    always @(posedge clk) begin
        if (L) begin
            q <= q_in;
        end else begin
            q <= r_in;
        end
    end

endmodule

endmodule
