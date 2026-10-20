
module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

    integer i;
    reg [2:0] pos_reg;

    always @(*) begin
        pos_reg = 3'b0;
        for (i = 0;
 i < 8;
 i = i + 1) begin
            case (i)
                0: if (in[0]) pos_reg = 3'b001;
                1: if (in[1]) pos_reg = 3'b010;
                2: if (in[2]) pos_reg = 3'b011;
                3: if (in[3]) pos_reg = 3'b100;
                4: if (in[4]) pos_reg = 3'b101;
                5: if (in[5]) pos_reg = 3'b110;
                6: if (in[6]) pos_reg = 3'b111;
                7: if (in[7]) pos_reg = 3'b1000;
                default: pos_reg = 3'b0;
            endcase
        end
    end

    assign pos = pos_reg;

endmodule
