
module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

    
    reg [99:0] reg;

    
    reg [99:0] q1, q2;

    
    reg [1:0] div;

    
    reg [1:0] count;

    
    always @(posedge clk) begin
        if (load) begin
            reg <= data;
        end
    end

    
    always @(posedge clk) begin
        if (ena[0]) begin
            
            q1 <= reg[99] ^ reg[98];
            q2 <= reg[97] ^ reg[96];
            
            q <= q1[98:0] ^ q2[97:0] ^ reg[95:0] ^ reg[94:0] ^ reg[93:0] ^ reg[92:0] ^ reg[91:0] ^ reg[90:0] ^ reg[89:0] ^ reg[88:0] ^ reg[87:0] ^ reg[86:0] ^ reg[85:0] ^ reg[84:0] ^ reg[83:0] ^ reg[82:0] ^ reg[81:0] ^ reg[80:0] ^ reg[79:0] ^ reg[78:0] ^ reg[77:0] ^ reg[76:0] ^ reg[75:0] ^ reg[74:0] ^ reg[73:0] ^ reg[72:0] ^ reg[71:0] ^ reg[70:0] ^ reg[69:0] ^ reg[68:0] ^ reg[67:0] ^ reg[66:0] ^ reg[65:0] ^ reg[64:0] ^ reg[63:0] ^ reg[62:0] ^ reg[61:0] ^ reg[60:0] ^ reg[59:0] ^ reg[58:0] ^ reg[57:0] ^ reg[56:0] ^ reg[55:0] ^ reg[54:0] ^ reg[53:0] ^ reg[52:0] ^ reg[51:0] ^ reg[50:0] ^ reg[49:0] ^ reg[48:0] ^ reg[47:0] ^ reg[46:0] ^ reg[45:0] ^ reg[44:0] ^ reg[43:0] ^ reg[42:0] ^ reg[41:0] ^ reg[40:0] ^ reg[39:0] ^ reg[38:0] ^ reg[37:0] ^ reg[36:0] ^ reg[35:0] ^ reg[34:0] ^ reg[33:0] ^ reg[32:0] ^ reg[31:0] ^ reg[30:0] ^ reg[29:0] ^ reg[28:0] ^ reg[27:0] ^ reg[26:0] ^ reg[25:0] ^ reg[24:0] ^ reg[23:0] ^ reg[22:0] ^ reg[21:0] ^ reg[20:0] ^ reg[19:0] ^ reg[18:0] ^ reg[17:0] ^ reg[16:0] ^ reg[15:0] ^ reg[14:0] ^ reg[13:0] ^ reg[12:0] ^ reg[11:0] ^ reg[10:0] ^ reg[9:0] ^ reg[8:0] ^ reg[7:0] ^ reg[6:0] ^ reg[5:0] ^ reg[4:0] ^ reg[3:0] ^ reg[2:0] ^ reg[1:0] ^ reg[0:0];
        end else if (ena[1]) begin
            
            q1 <= reg[0] ^ reg[1];
            q2 <= reg[1] ^ reg[2];
            
            q <= q1[1:0] ^ q2[0:1] ^ reg[9] ^ reg[8] ^ reg[7] ^ reg[6] ^ reg[5] ^ reg[4] ^ reg[3] ^ reg[2] ^ reg[1] ^ reg[0];
        end else begin
            
            q <= reg;
        end
    end

    
    always @(posedge clk) begin
        if (ena[0]) begin
            count <= count + 1;
        end else if (ena[1]) begin
            count <= count + 1;
        end else begin
            count <= count;
        end
    end

    
    always @(posedge clk) begin
        if (count == 1) begin
            div <= div + 1;
        end else begin
            div <= div;
        end
    end

    
    always @(posedge clk) begin
        if (div == 1) begin
            q <= q;
        end else begin
            q <= q;
        end
    end

endmodule
