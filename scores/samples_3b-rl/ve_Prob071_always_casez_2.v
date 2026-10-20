
module TopModule(
    input [7:0] in,
    output reg [2:0] pos
);

    integer i;
    reg [2:0] pos_reg;

    always @(*) begin
        pos_reg = 3'd0;
        for (i = 0;
 i < 8;
 i = i + 1) begin
            case (in[i])
                1'b1: begin
                    pos_reg = i;
                    break;
                end
                default: begin
                    
                end
            endcase
        end
        pos = pos_reg;
    end

endmodule
