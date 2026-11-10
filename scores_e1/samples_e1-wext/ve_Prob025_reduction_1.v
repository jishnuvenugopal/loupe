
module TopModule (
    input wire [7:0] in,  
    output reg parity    
);

    
    assign parity = in ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7];

endmodule
