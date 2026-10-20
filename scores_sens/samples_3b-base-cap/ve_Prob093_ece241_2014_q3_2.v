
module TopModule (
    input c,
    input d,
    output reg [3:0] mux_in
);

    
    reg [3:0] mux1_out;
    reg [3:0] mux2_out;
    reg [3:0] mux3_out;
    reg [3:0] mux4_out;

    
    mux1_out = (c & d) ? d : c;

    
    mux2_out = (c & d) ? c : d;

    
    mux3_out = (c & d) ? d : c;

    
    mux4_out = (c & d) ? c : d;

    
    mux_in = {mux4_out, mux3_out, mux2_out, mux1_out};

endmodule
