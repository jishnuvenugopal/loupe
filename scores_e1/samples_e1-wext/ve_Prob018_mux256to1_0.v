
module TopModule (
    input wire [255:0] in,  
    input wire [7:0] sel,   
    output reg out        
);

    reg [7:0] selectedBit;
  

    always @(sel) begin
        
        case (sel)
            8'b00000000: selectedBit = in[0];
            8'b00000001: selectedBit = in[1];
            8'b00000010: selectedBit = in[2];
            8'b00000011: selectedBit = in[3];
            8'b00000100: selectedBit = in[4];
            8'b00000101: selectedBit = in[5];
            8'b00000110: selectedBit = in[6];
            8'b00000111: selectedBit = in[7];
            8'b00001000: selectedBit = in[8];
            8'b00001001: selectedBit = in[9];
            8'b00001010: selectedBit = in[10];
            8'b00001011: selectedBit = in[11];
            8'b00001100: selectedBit = in[12];
            8'b00001101: selectedBit = in[13];
            8'b00001110: selectedBit = in[14];
            8'b00001111: selectedBit = in[15];
            8'b00010000: selectedBit = in[16];
            8'b00010001: selectedBit = in[17];
            8'b00010010: selectedBit = in[18];
            8'b00010011: selectedBit = in[19];
            8'b00010100: selectedBit = in[20];
            8'b00010101: selectedBit = in[21];
            8'b00010110: selectedBit = in[22];
            8'b00010111: selectedBit = in[23];
            8'b00011000: selectedBit = in[24];
            8'b00011001: selectedBit = in[25];
            8'b00011010: selectedBit = in[26];
            8'b00011011: selectedBit = in[27];
            8'b00011100: selectedBit = in[28];
            8'b00011101: selectedBit = in[29];
            8'b00011110: selectedBit = in[30];
            8'b00011111: selectedBit = in[31];
            default: selectedBit = 8'b00000000;
  
        endcase
    end

    assign out = selectedBit;
  

endmodule
