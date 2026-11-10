
module TopModule (
    input wire c,
    input wire d,
    output reg [3:0] mux_in
);

    
    assign mux_in[0] = d * (c + d);

    
    assign mux_in[1] = c * (c + d);

    
    assign mux_in[2:0] = {mux_in[0], mux_in[1]};

endmodule
