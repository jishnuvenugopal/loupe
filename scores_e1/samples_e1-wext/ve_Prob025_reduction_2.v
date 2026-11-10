
module TopModule (
    input wire [7:0] in,
    output reg parity
);

    
    assign parity = in ^ in[7];

endmodule
