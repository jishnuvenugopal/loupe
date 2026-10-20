
module TopModule (
    input  wire c,
    input  wire d,
    output wire [3:0] mux_in
);

    wire [3:0] mux_4to1_out;
    wire [3:0] mux_2to1_out;
    wire [3:0] mux_2to1_data0;
    wire [3:0] mux_2to1_data1;
    wire [3:0] mux_2to1_data2;
    wire [3:0] mux_2to1_data3;
    wire ab;

    
    assign mux_2to1_data0 = 4'b0001;
    assign mux_2to1_data1 = 4'b0010;
    assign mux_2to1_data2 = 4'b0100;
    assign mux_2to1_data3 = 4'b1000;

    
    assign mux_2to1_data0 = 4'b0000;
    assign mux_2to1_data1 = 4'b0000;
    assign mux_2to1_data2 = 4'b0000;
    assign mux_2to1_data3 = 4'b0000;

    
    assign mux_2to1_data0 = 4'b0000;
    assign mux_2to1_data1 = 4'b0000;
    assign mux_2to1_data2 = 4'b0000;
    assign mux_2to1_data3 = 4'b0000;

    
    assign mux_2to1_data0 = 4'b0000;
    assign mux_2to1_data1 = 4'b0000;
    assign mux_2to1_data2 = 4'b0000;
    assign mux_2to1_data3 = 4'b0000;

    
    assign ab = {c, d};
    mux_4to1 mux_4to1_inst (
        .a  (mux_2to1_out),
        .b  (mux_2to1_data0),
        .c  (mux_2to1_data1),
        .d  (mux_2to1_data2),
        .e  (mux_2to1_data3),
        .sel(ab),
        .y  (mux_4to1_out)
    );

    
    assign mux_2to1_out = (ab == 2'b01) ? mux_2to1_data1 : mux_4to1_out;

    
    assign mux_2to1_out = (ab == 2'b11) ? mux_2to1_data2 : mux_2to1_out;

    
    assign mux_2to1_out = (ab == 2'b10) ? mux_2to1_data3 : mux_2to1_out;

    
    assign mux_in = mux_2to1_out;

endmodule
