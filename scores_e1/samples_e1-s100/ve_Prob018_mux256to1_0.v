
module TopModule (
    input wire [255:0] in,  
    input wire [7:0]  sel,  
    output reg [0:0] out   
);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            out <= 0;
  
        end else begin
            case (sel)
                8'b00000000: out <= in[0];
  
                8'b00000001: out <= in[1];
  
                8'b00000010: out <= in[2];
  
                8'b00000011: out <= in[3];
  
                8'b00000100: out <= in[4];
  
                8'b00000101: out <= in[5];
  
                8'b00000110: out <= in[6];
  
                8'b00000111: out <= in[7];
  
                8'b00001000: out <= in[8];
  
                8'b00001001: out <= in[9];
  
                8'b00001010: out <= in[10];
 
                8'b00001011: out <= in[11];
 
                8'b00001100: out <= in[12];
 
                8'b00001101: out <= in[13];
 
                8'b00001110: out <= in[14];
 
                8'b00001111: out <= in[15];
 
                8'b00010000: out <= in[16];
 
                8'b00010001: out <= in[17];
 
                8'b00010010: out <= in[18];
 
                8'b00010011: out <= in[19];
 
                8'b00010100: out <= in[20];
 
                8'b00010101: out <= in[21];
 
                8'b00010110: out <= in[22];
 
                8'b00010111: out <= in[23];
 
                8'b00011000: out <= in[24];
 
                8'b00011001: out <= in[25];
 
                8'b00011010: out <= in[26];
 
                8'b00011011: out <= in[27];
 
                8'b00011100: out <= in[28];
 
                8'b00011101: out <= in[29];
 
                8'b00011110: out <= in[30];
 
                8'b00011111: out <= in[31];
 
                default: out <= 0;
  
            endcase
        end
    end

endmodule
