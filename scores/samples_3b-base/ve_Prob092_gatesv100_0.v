
module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    
    generate
        for (genvar i = 0;
 i < 100;
 i++) begin
            assign out_both[i] = (in[i] == 1'b1) && (i > 0 ? in[i-1] == 1'b1 : 1'b0);
        end
    endgenerate

    
    generate
        for (genvar i = 0;
 i < 100;
 i++) begin
            assign out_any[i] = (in[i] == 1'b1) || (i < 99 ? in[i+1] == 1'b1 : 1'b0);
        end
    endgenerate

    
    generate
        for (genvar i = 0;
 i < 100;
 i++) begin
            assign out_different[i] = (in[i] != in[i-1]);
        end
    endgenerate

endmodule
