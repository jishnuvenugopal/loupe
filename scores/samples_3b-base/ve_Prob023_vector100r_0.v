
module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    
    for (genvar i = 99;
 i >= 0;
 i = i - 1) begin
        
        out[i] = in[i];
    end

endmodule
