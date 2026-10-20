
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);

    integer i;

    always @(*) begin
        for (i = 0;
 i < 25;
 i = i + 1) begin
            if (i < 5) begin
                
                out[i] = ~(a[i] ^ b[i]);
            end else if (i < 10) begin
                
                out[i] = ~(a[i] ^ c[i]);
            end else if (i < 15) begin
                
                out[i] = ~(a[i] ^ d[i]);
            end else if (i < 20) begin
                
                out[i] = ~(a[i] ^ e[i]);
            end else begin
                
                out[i] = ~(b[i-20] ^ c[i-20]);
            end
        end
    end

endmodule
