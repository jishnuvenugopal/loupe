
module mux2X1 (
    input sel,
    input [7:0] in0,
    input [7:0] in1,
    output [7:0] out
);
    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    wire [7:0] stage1, stage2;
    
    mux2X1 mux4 (
        .sel(ctrl[2]),
        .in0(in),
        .in1({4'b0, in[7:4]}),
        .out(stage1)
    );
    
    mux2X1 mux2 (
        .sel(ctrl[1]),
        .in0(stage1),
        .in1({2'b0, stage1[7:2]}),
        .out(stage2)
    );
    
    mux2X1 mux1 (
        .sel(ctrl[0]),
        .in0(stage2),
        .in1({1'b0, stage2[7:1]}),
        .out(out)
    );
endmodule
