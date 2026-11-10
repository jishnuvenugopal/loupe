
module TopModule (
    input  [7:0] in,
    output reg [2:0] pos
);

    reg [2:0] count;

    always @(in) begin
        count = 0;
        pos = 0;

        for (int i = 0;
 i < 8;
 i++) begin
            if (in[i] == 1) begin
                pos = i;
                count = i + 1;
                break;
            end
        end
    end

endmodule
