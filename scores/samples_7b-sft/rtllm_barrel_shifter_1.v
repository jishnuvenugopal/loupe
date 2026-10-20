
module mux2X1(
    input [7:0] a,
    input [7:0] b,
    input sel,
    output [7:0] out
);
    assign out = sel ? b : a;
endmodule

module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    wire [7:0] stage1_out, stage2_out;
    
    mux2X1 mux_stage1(
        .a(in),
        .b({4'b0, in[7:4]}),
        .sel(ctrl[2]),
        .out(stage1_out)
    );
    
    mux2X1 mux_stage2(
        .a(stage1_out),
        .b({2'b0, stage1_out[7:2]}),
        .sel(ctrl[1]),
        .out(stage2_out)
    );
    
    mux2X1 mux_stage3(
        .a(stage2_out),
        .b({1'b0, stage2_out[7:1]}),
        .sel(ctrl[0]),
        .out(out)
    );
    
endmodule
