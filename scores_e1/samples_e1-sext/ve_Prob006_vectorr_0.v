
module TopModule (
    input  [7:0] in,
    output [7:0] out
);

    always @(*) begin
        out = in[7:0];
    end

endmodule
