
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);

    
    reg [24:0] out_reg = 25'b0;

    
    for (genvar i = 0;
 i < 5;
 i++) begin
        
        for (genvar j = 0;
 j < 5;
 j++) begin
            
            reg compare = ~a[i] ^ a[j];
            
            out_reg[i * 5 + j] = compare;
        end
    end

    
    assign out = out_reg;

endmodule
