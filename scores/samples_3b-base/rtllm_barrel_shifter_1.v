
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

    
    reg [7:0] shift4;
    reg [7:0] shift2;
    reg [7:0] shift1;

    
    mux2X1 shift4_mux (
        .a(in),
        .b({{4{1'b0}}, in[7:4]}),
        .sel(ctrl[2]),
        .y(shift4)
    );

    
    mux2X1 shift2_mux (
        .a(shift4),
        .b({{2{1'b0}}, shift4[7:2]}),
        .sel(ctrl[1]),
        .y(shift2)
    );

    
    mux2X1 shift1_mux (
        .a(shift2),
        .b({{1{1'b0}}, shift2[7:1]}),
        .sel(ctrl[0]),
        .y(out)
    );

endmodule
