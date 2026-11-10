
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);

    always @(*) begin
        for (int i = 0;
 i < 25;
 i++) begin
            out[i] = ~a ^ a;
 
            out[i] = ~a ^ b;
 
            out[i] = ~a ^ c;
 
            
            
            out[i] = ~e ^ d;
 
            out[i] = ~e ^ e;
 
        end
    end

endmodule
