
module TopModule (
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] s,
    output reg overflow
);

always @(*) begin
    
    s = a + b;
    
    
    
    
    if ((a[7] == b[7] && s[7] != a[7]) || (a[7] != b[7] && s[7] != a[7]))
        overflow = 1'b1;
    else
        overflow = 1'b0;
end




endmodule
