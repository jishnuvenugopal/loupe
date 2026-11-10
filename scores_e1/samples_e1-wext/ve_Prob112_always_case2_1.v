
module TopModule (
    input  [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        if (in == 4'b0000) begin
            pos = 2'b00;
        end else begin
            pos = 2'b00;
            for (int i = 0;
 i < 4;
 i++) begin
                if (in[i] == 1'b1) begin
                    pos = 2'b01;
                    break;
                end
            end
        end
    end

endmodule
