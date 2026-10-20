
module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);

    
    localparam NUM_STAGES = 3;

    
    submodule mux2X1 (
        input [7:0] a,
        input [7:0] b,
        input sel,
        output reg [7:0] y
    );

    
    mux2X1 m0 (.a(in), .b({{8{in[7]}}, in[6:0]}), .sel(ctrl[2]), .y(out[7:0]));
    mux2X1 m1 (.a(out[7:0]), .b({{8{out[7]}}, out[6:0]}), .sel(ctrl[1]), .y(out[7:0]));
    mux2X1 m2 (.a(out[7:0]), .b({{8{out[7]}}, out[6:0]}), .sel(ctrl[0]), .y(out[7:0]));

endmodule
