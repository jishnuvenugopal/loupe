
module TopModule (
    input  [1023:0] in,  
    input  [  7:0] sel,  
    output [  3:0] out   
);

    
    always @(*) begin
        case (sel)
            8'h00: out = in[3:0];
  
            8'h01: out = in[7:4];
  
            8'h02: out = in[11:8];
 
            8'h03: out = in[15:12];
 
            8'h04: out = in[19:16];
 
            8'h05: out = in[23:20];
 
            8'h06: out = in[27:24];
 
            8'h07: out = in[31:28];
 
            8'h08: out = in[35:32];
 
            8'h09: out = in[39:36];
 
            8'h0A: out = in[43:40];
 
            8'h0B: out = in[47:44];
 
            8'h0C: out = in[51:48];
 
            8'h0D: out = in[55:52];
 
            8'h0E: out = in[59:56];
 
            8'h0F: out = in[63:60];
 
            8'h10: out = in[67:64];
 
            8'h11: out = in[71:68];
 
            8'h12: out = in[75:72];
 
            8'h13: out = in[79:76];
 
            8'h14: out = in[83:80];
 
            8'h15: out = in[87:84];
 
            8'h16: out = in[91:88];
 
            8'h17: out = in[95:92];
 
            8'h18: out = in[99:96];
 
            8'h19: out = in[103:100];
 
            8'h1A: out = in[107:104];
 
            8'h1B: out = in[111:108];
 
            8'h1C: out = in[115:112];
 
            8'h1D: out = in[119:116];
 
            8'h1E: out = in[123:120];
 
            8'h1F: out = in[127:124];
 
            8'h20: out = in[131:128];
 
            8'h21: out = in[135:132];
 
            8'h22: out = in[139:136];
 
            8'h23: out = in[143:140];
 
            8'h24: out = in[147:144];
 
            8'h25: out = in[151:148];
 
            8'h26: out = in[155:152];
 
            8'h27: out = in[159:156];
 
            8'h28: out = in[163:160];
 
            8'h29: out = in[167:164];
 
            8'h2A: out = in[171:168];
 
            8'h2B: out = in[175:172];
 
            8'h2C: out = in[179:176];
 
            8'h2D: out = in[183:180];
 
            8'h2E: out = in[187:184];
 
            8'h2F: out = in[191:188];
 
            8'h30: out = in[195:192];
 
            8'h31: out = in[199:196];
 
            8'h32: out = in[203:200];
 
            8'h33: out = in[207:204];
 
            8'h34: out = in[211:208];
 
            8'h35: out = in[215:212];
 
            8'h36: out = in[219:216];
 
            8'h37: out = in[223:220];
 
            8'h38: out = in[227:224];
 
            8'h39: out = in[231:228];
 
            8'h3A: out = in[235:232];
 
            8'h3B: out = in[239:236];
 
            8'h3C: out = in[243:240];
 
            8'h3D: out = in[247:244];
 
            8'h3E: out = in[251:248];
 
            8'h3F: out = in[255:252];
 
            default: out = 4'b0;
 
        endcase
    end

endmodule
