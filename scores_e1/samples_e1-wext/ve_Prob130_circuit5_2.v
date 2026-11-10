
module TopModule (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire [3:0] c,
    input wire [3:0] d,
    input wire [3:0] e,
    output reg [3:0] q
);

always @(a, b, c, d, e) begin
    case (a)
        4'b0000: q = 4'b0000;
        4'b0001: q = 4'b0001;
        4'b0010: q = 4'b0010;
        4'b0011: q = 4'b0011;
        4'b0100: q = 4'b0100;
        4'b0101: q = 4'b0101;
        4'b0110: q = 4'b0110;
        4'b0111: q = 4'b0111;
        4'b1000: q = 4'b1000;
        4'b1001: q = 4'b1001;
        4'b1010: q = 4'b1010;
        4'b1011: q = 4'b1011;
        4'b1100: q = 4'b1100;
        4'b1101: q = 4'b1101;
        4'b1110: q = 4'b1110;
        4'b1111: q = 4'b1111;
    endcase
end

endmodule
