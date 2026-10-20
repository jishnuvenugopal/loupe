
module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output reg  ringer,
    output reg  motor
);

    wire mux_out;

    
    assign mux_out = (ring & vibrate_mode) ? motor : ringer;

    
    assign ringer = mux_out;
    assign motor  = mux_out;

endmodule
