
module TopModule (
    input  [31:0] in,
    output [31:0] out
);


reg [7:0] byte0 = in[7:0];
reg [7:0] byte1 = in[15:8];
reg [7:0] byte2 = in[23:16];
reg [7:0] byte3 = in[31:24];


wire [31:0] reversed = {byte3, byte2, byte1, byte0};


assign out = reversed;

endmodule
