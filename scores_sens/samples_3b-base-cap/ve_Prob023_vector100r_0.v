
module TopModule (
    input  [99:0] in,  
    output [99:0] out   
);

    
    for (int i = 99;
 i >= 0;
 i--) begin
        out[i] = in[i];
  
    end

endmodule
