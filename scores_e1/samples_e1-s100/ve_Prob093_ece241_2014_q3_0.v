
module TopModule (
    input wire c,
    input wire d,
    output reg [3:0] mux_in
);
    wire [1:0] ab;
    wire [1:0] ab_c;
    wire [1:0] ab_d;

    
    assign ab = {c, d};

    
    assign ab_c = {ab[0], c};

    
    assign ab_d = {ab[0], d};

    
    mux2_1 mux1 (
        .a(c),
        .b(d),
        .s(ab[1]),
        .y(mux_in[0])
    );

    
    mux2_1 mux2 (
        .a(c),
        .b(d),
        .s(ab_c[1]),
        .y(mux_in[1])
    );

    
    mux2_1 mux3 (
        .a(c),
        .b(d),
        .s(ab_d[1]),
        .y(mux_in[2])
    );
endmodule
