
module TopModule (
    input  wire c,
    input  wire d,
    output reg  [3:0] mux_in
);

    
    wire mux1_in, mux2_in, mux3_in, mux4_in;
    wire mux1_a, mux1_b, mux2_a, mux2_b, mux3_a, mux3_b, mux4_a, mux4_b;

    
    assign mux1_a = 1'b0;
    assign mux1_b = 1'b0;
    assign mux1_in = (c) ? c : d;

    
    assign mux2_a = 1'b0;
    assign mux2_b = 1'b1;
    assign mux2_in = (c) ? c : d;

    
    assign mux3_a = 1'b1;
    assign mux3_b = 1'b0;
    assign mux3_in = (c) ? c : d;

    
    assign mux4_a = 1'b1;
    assign mux4_b = 1'b1;
    assign mux4_in = (c) ? c : d;

    
    assign mux_in[0] = mux1_in;
    assign mux_in[1] = mux2_in;
    assign mux_in[2] = mux3_in;
    assign mux_in[3] = mux4_in;

endmodule
