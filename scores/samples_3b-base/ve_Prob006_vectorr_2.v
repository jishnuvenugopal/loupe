
module TopModule (
    input  [7:0] in,  
    output [7:0] out   
);

    
    reg [7:0] reversed_bits;

    
    for (genvar i = 0;
 i < 8;
 i = i + 1) begin
        
        reversed_bits[i] = in[7 - i];
    end

    
    assign out = reversed_bits;

endmodule
