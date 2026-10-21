
module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    
    reg [63:0] data_reg;

    
    reg [63:0] shift_reg;

    
    always @(posedge clk or posedge load or posedge ena) begin
        if (load) begin
            data_reg <= data;
            shift_reg <= data;
        end else if (ena) begin
            case (amount)
                2'b00: shift_reg <= {data_reg[63], data_reg[62:0]};
                2'b01: shift_reg <= {data_reg[63], data_reg[62:0], data_reg[61:0], data_reg[60:0], data_reg[59:0], data_reg[58:0], data_reg[57:0], data_reg[56:0], data_reg[55:0], data_reg[54:0], data_reg[53:0], data_reg[52:0], data_reg[51:0], data_reg[50:0], data_reg[49:0], data_reg[48:0], data_reg[47:0], data_reg[46:0], data_reg[45:0], data_reg[44:0], data_reg[43:0], data_reg[42:0], data_reg[41:0], data_reg[40:0], data_reg[39:0], data_reg[38:0], data_reg[37:0], data_reg[36:0], data_reg[35:0], data_reg[34:0], data_reg[33:0], data_reg[32:0], data_reg[31:0], data_reg[30:0], data_reg[29:0], data_reg[28:0], data_reg[27:0], data_reg[26:0], data_reg[25:0], data_reg[24:0], data_reg[23:0], data_reg[22:0], data_reg[21:0], data_reg[20:0], data_reg[19:0], data_reg[18:0], data_reg[17:0], data_reg[16:0], data_reg[15:0], data_reg[14:0], data_reg[13:0], data_reg[12:0], data_reg[11:0], data_reg[10:0], data_reg[9:0], data_reg[8:0], data_reg[7:0], data_reg[6:0], data_reg[5:0], data_reg[4:0], data_reg[3:0], data_reg[2:0], data_reg[1:0], data_reg[0:0]};
                2'b10: shift_reg <= {data_reg[63], data_reg[62:0], data_reg[61:0], data_reg[60:0], data_reg[59:0], data_reg[58:0], data_reg[57:0], data_reg[56:0], data_reg[55:0], data_reg[54:0], data_reg[53:0], data_reg[52:0], data_reg[51:0], data_reg[50:0], data_reg[49:0], data_reg[48:0], data_reg[47:0], data_reg[46:0], data_reg[45:0], data_reg[44:0], data_reg[43:0], data_reg[42:0], data_reg[41:0], data_reg[40:0], data_reg[39:0], data_reg[38:0], data_reg[37:0], data_reg[36:0], data_reg[35:0], data_reg[34:0], data_reg[33:0], data_reg[32:0], data_reg[31:0], data_reg[30:0], data_reg[29:0], data_reg[28:0], data_reg[27:0], data_reg[26:0], data_reg[25:0], data_reg[24:0], data_reg[23:0], data_reg[22:0], data_reg[21:0], data_reg[20:0], data_reg[19:0], data_reg[18:0], data_reg[17:0], data_reg[16:0], data_reg[15:0], data_reg[14:0], data_reg[13:0], data_reg[12:0], data_reg[11:0], data_reg[10:0], data_reg[9:0], data_reg[8:0], data_reg[7:0], data_reg[6:0], data_reg[5:0], data_reg[4:0], data_reg[3:0], data_reg[2:0], data_reg[1:0], data_reg[0:0]};
                2'b11: shift_reg <= {data_reg[63], data_reg[62:0], data_reg[61:0], data_reg[60:0], data_reg[59:0], data_reg[58:0], data_reg[57:0], data_reg[56:0], data_reg[55:0], data_reg[54:0], data_reg[53:0], data_reg[52:0], data_reg[51:0], data_reg[50:0], data_reg[49:0], data_reg[48:0], data_reg[47:0], data_reg[46:0], data_reg[45:0], data_reg[44:0], data_reg[43:0], data_reg[42:0], data_reg[41:0], data_reg[40:0], data_reg[39:0], data_reg[38:0], data_reg[37:0], data_reg[36:0], data_reg[35:0], data_reg[34:0], data_reg[33:0], data_reg[32:0], data_reg[31:0], data_reg[30:0], data_reg[29:0], data_reg[28:0], data_reg[27:0], data_reg[26:0], data_reg[25:0], data_reg[24:0], data_reg[23:0], data_reg[22:0], data_reg[21:0], data_reg[20:0], data_reg[19:0], data_reg[18:0], data_reg[17:0], data_reg[16:0], data_reg[15:0], data_reg[14:0], data_reg[13:0], data_reg[12:0], data_reg[11:0], data_reg[10:0], data_reg[9:0], data_reg[8:0], data_reg[7:0], data_reg[6:0], data_reg[5:0], data_reg[4:0], data_reg[3:0], data_reg[2:0], data_reg[1:0], data_reg[0:0]};
            endcase
        end
    end

    
    assign q = shift_reg;

endmodule
