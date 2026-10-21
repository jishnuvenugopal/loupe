

interface TopModuleInterface (
    input  wire [7:0] in,
    output wire [7:0] out
);

endinterface


module TopModule (
    input  wire [7:0] in,
    output wire [7:0] out
);

    
    assign out = in[7:0] ^ in[6:1] ^ in[5:2] ^ in[4:3] ^ in[3:0];

endmodule
