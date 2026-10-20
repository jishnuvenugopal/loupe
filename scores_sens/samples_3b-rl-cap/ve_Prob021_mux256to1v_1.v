
module TopModule (
    input [1023:0] in,
    input [7:0] sel,
    output reg [3:0] out
);

always @(*) begin
    case(sel)
        8'b00000000: out = in[3:0];
 
        8'b00000001: out = in[7:4];
 
        8'b00000010: out = in[11:8];
 
        8'b00000011: out = in[15:12];
 
        8'b00000100: out = in[19:16];
 
        8'b00000101: out = in[23:20];
 
        8'b00000110: out = in[27:24];
 
        8'b00000111: out = in[31:28];
 
        8'b00001000: out = in[35:32];
 
        8'b00001001: out = in[39:36];
 
        8'b00001010: out = in[43:40];
 
        8'b00001011: out = in[47:44];
 
        8'b00001100: out = in[51:48];
 
        8'b00001101: out = in[55:52];
 
        8'b00001110: out = in[59:56];
 
        8'b00001111: out = in[63:60];
 
        8'b00010000: out = in[67:64];
 
        8'b00010001: out = in[71:68];
 
        8'b00010010: out = in[75:72];
 
        8'b00010011: out = in[79:76];
 
        8'b00010100: out = in[83:80];
 
        8'b00010101: out = in[87:84];
 
        8'b00010110: out = in[91:88];
 
        8'b00010111: out = in[95:92];
 
        default: out = 4'b0000;
    endcase
end

endmodule
