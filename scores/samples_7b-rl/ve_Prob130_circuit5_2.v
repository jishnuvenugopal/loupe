
module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

    assign q = (e == 4'd0) ? 4'hB :
               (e == 4'd1) ? 4'hE :
               (e == 4'd2) ? 4'hA :
               (e == 4'd3) ? 4'hD : 4'hF;

endmodule
