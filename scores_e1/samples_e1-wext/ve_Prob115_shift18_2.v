
module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    
    reg [63:0] shift_reg;

    always @(posedge clk or posedge load) begin
        if (load) begin
            shift_reg <= data;
        end else if (ena) begin
            case (amount)
                2'b00: shift_reg <= {shift_reg[63], shift_reg[62:0]};
                2'b01: shift_reg <= {shift_reg[63], shift_reg[62:0], shift_reg[61:0], shift_reg[60:0], shift_reg[59:0], shift_reg[58:0], shift_reg[57:0], shift_reg[56:0], shift_reg[55:0], shift_reg[54:0], shift_reg[53:0], shift_reg[52:0], shift_reg[51:0], shift_reg[50:0], shift_reg[49:0], shift_reg[48:0], shift_reg[47:0], shift_reg[46:0], shift_reg[45:0], shift_reg[44:0], shift_reg[43:0], shift_reg[42:0], shift_reg[41:0], shift_reg[40:0], shift_reg[39:0], shift_reg[38:0], shift_reg[37:0], shift_reg[36:0], shift_reg[35:0], shift_reg[34:0], shift_reg[33:0], shift_reg[32:0], shift_reg[31:0], shift_reg[30:0], shift_reg[29:0], shift_reg[28:0], shift_reg[27:0], shift_reg[26:0], shift_reg[25:0], shift_reg[24:0], shift_reg[23:0], shift_reg[22:0], shift_reg[21:0], shift_reg[20:0], shift_reg[19:0], shift_reg[18:0], shift_reg[17:0], shift_reg[16:0], shift_reg[15:0], shift_reg[14:0], shift_reg[13:0], shift_reg[12:0], shift_reg[11:0], shift_reg[10:0], shift_reg[9:0], shift_reg[8:0], shift_reg[7:0], shift_reg[6:0], shift_reg[5:0], shift_reg[4:0], shift_reg[3:0], shift_reg[2:0], shift_reg[1:0], shift_reg[0:0]};
                2'b10: shift_reg <= {shift_reg[63], shift_reg[62:0], shift_reg[61:0], shift_reg[60:0], shift_reg[59:0], shift_reg[58:0], shift_reg[57:0], shift_reg[56:0], shift_reg[55:0], shift_reg[54:0], shift_reg[53:0], shift_reg[52:0], shift_reg[51:0], shift_reg[50:0], shift_reg[49:0], shift_reg[48:0], shift_reg[47:0], shift_reg[46:0], shift_reg[45:0], shift_reg[44:0], shift_reg[43:0], shift_reg[42:0], shift_reg[41:0], shift_reg[40:0], shift_reg[39:0], shift_reg[38:0], shift_reg[37:0], shift_reg[36:0], shift_reg[35:0], shift_reg[34:0], shift_reg[33:0], shift_reg[32:0], shift_reg[31:0], shift_reg[30:0], shift_reg[29:0], shift_reg[28:0], shift_reg[27:0], shift_reg[26:0], shift_reg[25:0], shift_reg[24:0], shift_reg[23:0], shift_reg[22:0], shift_reg[21:0], shift_reg[20:0], shift_reg[19:0], shift_reg[18:0], shift_reg[17:0], shift_reg[16:0], shift_reg[15:0], shift_reg[14:0], shift_reg[13:0], shift_reg[12:0], shift_reg[11:0], shift_reg[10:0], shift_reg[9:0], shift_reg[8:0], shift_reg[7:0], shift_reg[6:0], shift_reg[5:0], shift_reg[4:0], shift_reg[3:0], shift_reg[2:0], shift_reg[1:0], shift_reg[0:0]};
                2'b11: shift_reg <= {shift_reg[63], shift_reg[62:0], shift_reg[61:0], shift_reg[60:0], shift_reg[59:0], shift_reg[58:0], shift_reg[57:0], shift_reg[56:0], shift_reg[55:0], shift_reg[54:0], shift_reg[53:0], shift_reg[52:0], shift_reg[51:0], shift_reg[50:0], shift_reg[49:0], shift_reg[48:0], shift_reg[47:0], shift_reg[46:0], shift_reg[45:0], shift_reg[44:0], shift_reg[43:0], shift_reg[42:0], shift_reg[41:0], shift_reg[40:0], shift_reg[39:0], shift_reg[38:0], shift_reg[37:0], shift_reg[36:0], shift_reg[35:0], shift_reg[34:0], shift_reg[33:0], shift_reg[32:0], shift_reg[31:0], shift_reg[30:0], shift_reg[29:0], shift_reg[28:0], shift_reg[27:0], shift_reg[26:0], shift_reg[25:0], shift_reg[24:0], shift_reg[23:0], shift_reg[22:0], shift_reg[21:0], shift_reg[20:0], shift_reg[19:0], shift_reg[18:0], shift_reg[17:0], shift_reg[16:0], shift_reg[15:0], shift_reg[14:0], shift_reg[13:0], shift_reg[12:0], shift_reg[11:0], shift_reg[10:0], shift_reg[9:0], shift_reg[8:0], shift_reg[7:0], shift_reg[6:0], shift_reg[5:0], shift_reg[4:0], shift_reg[3:0], shift_reg[2:0], shift_reg[1:0], shift_reg[0:0]};
            endcase
        end
    end

    assign q = shift_reg;

endmodule
