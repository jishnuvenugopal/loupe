
module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    assign q = (c == 4'b0000) ? b :
               (c == 4'b0001) ? e :
               (c == 4'b0010) ? a :
               (c == 4'b0011) ? d :
               (c == 4'b0100) ? f :
               (c == 4'b0101) ? f :
               (c == 4'b0110) ? f :
               (c == 4'b0111) ? f :
               (c == 4'b1000) ? f :
               (c == 4'b1001) ? f :
               (c == 4'b1010) ? f :
               (c == 4'b1011) ? f :
               (c == 4'b1100) ? f :
               (c == 4'b1101) ? f :
               (c == 4'b1110) ? f :
               (c == 4'b1111) ? f;

endmodule
