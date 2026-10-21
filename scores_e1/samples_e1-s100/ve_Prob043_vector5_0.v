
module TopModule (
    input  bit a,
    input  bit b,
    input  bit c,
    input  bit d,
    input  bit e,
    output bit [24:0] out
);

    
    assign out = 25'b0;

    
    for (genvar i = 0;
 i < 25;
 i = i + 1) begin
        
        assign out[i] = ~a ^ b ^ c ^ d ^ e;
    end

endmodule
