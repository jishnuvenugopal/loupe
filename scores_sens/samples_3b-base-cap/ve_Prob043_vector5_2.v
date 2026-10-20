
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);


assign out = 25'b0;


generate
    for (genvar i = 0;
 i < 5;
 i++) begin
        for (genvar j = i + 1;
 j < 5;
 j++) begin
            
            assign out[24 - (i * 5 + j)] = ~a[i] ^ a[j];
        end
    end
endgenerate

endmodule
