
module mux2X1 (
    input [7:0] a,
    input [7:0] b,
    input sel,
    output [7:0] out
);
    assign out = sel ? b : a;
endmodule

module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    wire [7:0] stage1, stage2;
    
    mux2X1 mux1 (
        .a(in),
        .b(in >>4),
        .sel(ctrl[2]),
        .out(stage1)
    );
    
    mux2X1 mux2 (
        .a(stage1),
        .b(stage1 >>2),
        .sel(ctrl[1]),
        .out(stage2)
    );
    
    mux2X1 mux3 (
        .a(stage2),
        .b(stage2 >>1),
        .sel(ctrl[0]),
        .out(out)
    );
endmodule
