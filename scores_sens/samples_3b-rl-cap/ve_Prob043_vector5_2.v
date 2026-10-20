
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);

    
    
    
    
    
    
    
    

    
    generate
        for (genvar i = 0;
 i < 25;
 i = i + 1) begin : output_assign
            
            
            
            assign out[i] = ~a ^ (a + 1 + i);
        end
    endgenerate

endmodule
