
module TopModule (
    input wire c,
    input wire d,
    output reg [3:0] mux_in
);

assign mux_in = {c, d};

endmodule
