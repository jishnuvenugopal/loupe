
module TopModule (
    input wire c,
    input wire d,
    output reg [3:0] mux_in
);

    
    reg d_mux_out;
    assign d_mux_out = c ? d : 0;

    
    reg c_mux_out;
    assign c_mux_out = d ? c : 0;

    
    assign mux_in = {d_mux_out, c_mux_out};

endmodule
