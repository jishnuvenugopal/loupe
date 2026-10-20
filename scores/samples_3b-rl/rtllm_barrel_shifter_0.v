
module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);

    
    wire [7:0] shift4_out;
    wire [7:0] shift2_out;
    wire [7:0] shift1_out;

    
    wire shift4;
    wire shift2;
    wire shift1;

    
    assign shift4 = ctrl[2];
    assign shift2 = ctrl[1];
    assign shift1 = ctrl[0];

    
    mux2X1 shift4_mux (
        .in0(in),
        .in1({8{1'b0}}),
        .sel(shift4),
        .out(shift4_out)
    );

    
    mux2X1 shift2_mux (
        .in0(shift4_out),
        .in1({6{1'b0}}),
        .sel(shift2),
        .out(shift2_out)
    );

    
    mux2X1 shift1_mux (
        .in0(shift2_out),
        .in1({7{1'b0}}),
        .sel(shift1),
        .out(shift1_out)
    );

    
    assign out = shift1_out;

endmodule


module mux2X1 (
    input [7:0] in0,
    input [7:0] in1,
    input sel,
    output reg [7:0] out
);
    always @(*) begin
        if (sel)
            out = in1;
        else
            out = in0;
    end
endmodule
