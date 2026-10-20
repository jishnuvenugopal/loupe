
module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

always @* begin
    case (c)
        4'h0: q = 4'hB;
        4'h1: q = 4'hE;
        4'h2: q = 4'hA;
        4'h3: q = 4'hD;
        default: q = 4'hF;
    endcase
end

endmodule
