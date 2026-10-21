
module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    
    reg [63:0] shift_register;

    
    always @(posedge clk or posedge load) begin
        if (load) begin
            shift_register <= data;
        end else if (ena) begin
            shift_register <= {shift_register[63], shift_register[62:0]};
        end
    end

    
    always @(posedge clk or posedge load) begin
        if (load) begin
            shift_register <= data;
        end else if (ena) begin
            shift_register <= {shift_register[63], shift_register[62:0], shift_register[61:0], shift_register[60:0], shift_register[59:0], shift_register[58:0], shift_register[57:0], shift_register[56:0], shift_register[55:0], shift_register[54:0], shift_register[53:0], shift_register[52:0], shift_register[51:0], shift_register[50:0], shift_register[49:0], shift_register[48:0], shift_register[47:0], shift_register[46:0], shift_register[45:0], shift_register[44:0], shift_register[43:0], shift_register[42:0], shift_register[41:0], shift_register[40:0], shift_register[39:0], shift_register[38:0], shift_register[37:0], shift_register[36:0], shift_register[35:0], shift_register[34:0], shift_register[33:0], shift_register[32:0], shift_register[31:0], shift_register[30:0], shift_register[29:0], shift_register[28:0], shift_register[27:0], shift_register[26:0], shift_register[25:0], shift_register[24:0], shift_register[23:0], shift_register[22:0], shift_register[21:0], shift_register[20:0], shift_register[19:0], shift_register[18:0], shift_register[17:0], shift_register[16:0], shift_register[15:0], shift_register[14:0], shift_register[13:0], shift_register[12:0], shift_register[11:0], shift_register[10:0], shift_register[9:0], shift_register[8:0], shift_register[7:0], shift_register[6:0], shift_register[5:0], shift_register[4:0], shift_register[3:0], shift_register[2:0], shift_register[1:0], shift_register[0:0]};
        end
    end

    
    always @(posedge clk or posedge load) begin
        if (load) begin
            shift_register <= data;
        end else if (ena) begin
            shift_register <= {shift_register[0], shift_register[1:64]};
        end
    end

    
    always @(posedge clk or posedge load) begin
        if (load) begin
            shift_register <= data;
        end else if (ena) begin
            shift_register <= {shift_register[0], shift_register[1:64], shift_register[63:56], shift_register[55:48], shift_register[47:40], shift_register[39:32], shift_register[31:24], shift_register[23:16], shift_register[15:8], shift_register[7:0]};
        end
    end

    
    assign q = shift_register;

endmodule
