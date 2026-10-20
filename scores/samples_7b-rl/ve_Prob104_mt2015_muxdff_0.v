
module SubModule (
    input clk,
    input L,
    input r_bit,
    input mux_in,
    output reg q
);
    always @(posedge clk) begin
        if (L)
            q <= r_bit;
        else
            q <= mux_in;
    end
endmodule

module TopModule (
    input clk,
    input L,
    input [2:0] r_in,
    output [2:0] Q
);
    SubModule sm2 (
        .clk(clk),
        .L(L),
        .r_bit(r_in[2]),
        .mux_in(Q[1] ^ Q[0]),
        .q(Q[2])
    );
    
    SubModule sm1 (
        .clk(clk),
        .L(L),
        .r_bit(r_in[1]),
        .mux_in(Q[0]),
        .q(Q[1])
    );
    
    SubModule sm0 (
        .clk(clk),
        .L(L),
        .r_bit(r_in[0]),
        .mux_in(Q[2]),
        .q(Q[0])
    );
endmodule
