
module TopModule (
    input [254:0] in,
    output [7:0] out
);

    wire [254:0] count;
    assign count = popcount(in);
    assign out = count[7:0];

endmodule
