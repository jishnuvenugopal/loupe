
module TopModule (
    input wire [1023:0] in,  
    input wire [7:0] sel,   
    output reg [3:0] out    
);

always @(*) begin
    case (sel)
        8'b0000: out = in[3:0];
  
        8'b0001: out = in[7:4];
  
        8'b0010: out = in[11:8];
 
        8'b0011: out = in[15:12];
 
        8'b0100: out = in[19:16];
 
        8'b0101: out = in[23:20];
 
        8'b0110: out = in[27:24];
 
        8'b0111: out = in[31:28];
 
        8'b1000: out = in[35:32];
 
        8'b1001: out = in[39:36];
 
        8'b1010: out = in[43:40];
 
        8'b1011: out = in[47:44];
 
        8'b1100: out = in[51:48];
 
        8'b1101: out = in[55:52];
 
        8'b1110: out = in[59:56];
 
        8'b1111: out = in[63:60];
 
    endcase
end

endmodule
