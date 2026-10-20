
module barrel_shifter (
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    
    wire [7:0] shift4, shift2, shift1;

    
    assign shift4 = {in[3:0], 4'b0000};

    
    assign shift2 = {in[1:0], 6'b000000};

    
    assign shift1 = {in[0], 7'b0000000};

    
    
    

    
    wire shift4_sel;
    assign shift4_sel = ctrl[2];
    wire [7:0] shift4_mux_out;
    mux2X1 u_shift4_mux (
        .a(shift4),
        .b(in),
        .sel(shift4_sel),
        .y(shift4_mux_out)
    );

    
    wire shift2_sel;
    assign shift2_sel = ctrl[1];
    wire [7:0] shift2_mux_out;
    mux2X1 u_shift2_mux (
        .a(shift2),
        .b(shift4_mux_out),
        .sel(shift2_sel),
        .y(shift2_mux_out)
    );

    
    wire shift1_sel;
    assign shift1_sel = ctrl[0];
    wire [7:0] shift1_mux_out;
    mux2X1 u_shift1_mux (
        .a(shift1),
        .b(shift2_mux_out),
        .sel(shift1_sel),
        .y(shift1_mux_out)
    );

    
    assign out = shift1_mux_out;

endmodule


module mux2X1 (
    input  [7:0] a,
    input  [7:0] b,
    input        sel,
    output [7:0] y
);
    assign y = sel ? a : b;
endmodule
