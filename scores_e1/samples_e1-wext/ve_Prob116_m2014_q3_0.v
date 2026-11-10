
module TopModule (
    input wire [3:0] x,
    output reg f
);

assign f = x[3] & x[4];

endmodule
