
module TopModule (
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] s,
    output reg overflow
);

    begin
        s = a + b;
        overflow = ((a[7] == b[7] && s[7] != a[7])) || (a[7] != b[7] && s[7] == a[7]);
    end

endmodule
