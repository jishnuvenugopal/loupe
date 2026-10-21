
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
            
            int bitIndex = i;
            
            input [1:0] pair = {a, b};
            
            out[bitIndex] = ~pair[0] ^ pair[1];
        end
    end

endmodule
