
module TopModule (
    input c,
    input d,
    output reg [3:0] mux_in
);

    
    reg [1:0] mux1_out;
    assign mux1_out = {c, d};

    
    reg [1:0] mux2_out;
    assign mux2_out = {d, c};

    
    assign mux_in = mux1_out * mux2_out;

endmodule
