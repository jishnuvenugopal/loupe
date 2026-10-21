
module SignExtender (
    input  [7:0] in,
    output [31:0] out
);

    reg [7:0] sign;
    reg [31:0] extended;

    always @(in) begin
        sign = in[7];
        for (int i = 0;
 i < 24;
 i = i + 1) begin
            extended = extended << 1;
            extended = extended | sign;
        end
        extended = extended | in;
        out = extended;
    end

endmodule
