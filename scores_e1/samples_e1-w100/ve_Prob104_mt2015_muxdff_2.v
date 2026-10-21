
module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg [2:0] Q
);

    
    flipflop ff (
        .clk(clk),
        .r(r_in),
        .q(Q)
    );

    
    mux2_1 mux (
        .L(L),
        .r(r_in),
        .Q(Q)
    );

endmodule

module flipflop (
    input  clk,
    input  r,
    output reg q
);

    always @(posedge clk) begin
        if (r) begin
            q <= 1'b1;
        end else begin
            q <= 1'b0;
        end
    end

endmodule

module mux2_1 (
    input  L,
    input  r,
    output reg Q
);

    always @(posedge clk) begin
        if (L) begin
            Q <= r;
        end else begin
            Q <= ~r;
        end
    end

endmodule

endmodule
