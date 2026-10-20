
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    integer i;

    assign out = 8'b0;

    for (i = 0;
 i < 8;
 i = i + 1) begin
        assign out[7-i] = in[i];
    end

endmodule
