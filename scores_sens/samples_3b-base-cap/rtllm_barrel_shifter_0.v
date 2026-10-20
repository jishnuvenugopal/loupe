
module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);

    
    module mux2X1 (
        input [7:0] a,
        input [7:0] b,
        input sel,
        output reg [7:0] y
    );
        always @(*) begin
            if (sel) y = a;
            else y = b;
        end
    endmodule

    
    reg [7:0] stage1, stage2, stage3;

    
    mux2X1 stage1_mux (
        .a(in),
        .b({{4{in[7]}}, in[3:0]}),
        .sel(ctrl[2]),
        .y(stage1)
    );

    
    mux2X1 stage2_mux (
        .a(stage1),
        .b({{2{stage1[7]}}, stage1[1:0]}),
        .sel(ctrl[1]),
        .y(stage2)
    );

    
    mux2X1 stage3_mux (
        .a(stage2),
        .b({{1{stage2[7]}}, stage2[0]}),
        .sel(ctrl[0]),
        .y(out)
    );

endmodule
