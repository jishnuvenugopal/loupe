
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*) begin
    case ({b, a, c, d})
        4'b0000: out = 0;
        4'b0001: out = 1;
        4'b1101: out = 0;
        4'b1110: out = 1;
        default: out = 1;
 
    endcase
end

endmodule
