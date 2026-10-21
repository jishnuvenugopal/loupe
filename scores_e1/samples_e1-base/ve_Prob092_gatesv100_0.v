
module TopModule (
    input  [99:0] in,  
    output [99:0] out_both,  
    output [99:0] out_any,  
    output [99:0] out_different  
);

    
    always @(*) begin
        out_both[99] = 0;
  
        out_any[0] = 0;
  

        for (int i = 0;
 i < 100;
 i++) begin
            out_both[i] = in[i] & in[i - 1];
            out_any[i] = in[i] | in[i + 1];
            out_different[i] = in[i] != in[i - 1];
        end
    end

endmodule
