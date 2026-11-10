
module TopModule (
    input  [7:0] in,  
    output [31:0] out  
);

    always @(*) begin
        
        out = in[7:0] << 24 | in;
    end

endmodule
