
module TopModule (
    input  wire [7:0] in,
    output reg  [7:0] out
);

    integer i;

    always @(*) begin
        for (i = 0;
 i < 8;
 i = i + 1) begin
            out[7-i] = in[i];
        end
    end

endmodule
