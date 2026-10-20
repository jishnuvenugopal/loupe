
module SignExtend8to32(input [7:0] in, output reg [31:0] out);
    assign out = {24{in[7]}, in};
endmodule
