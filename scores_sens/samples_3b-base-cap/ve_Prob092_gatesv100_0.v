
module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    
    genvar i;
    generate
        for (i = 0;
 i < 100;
 i++) begin
            assign out_both[i] = (in[i] == 1) && (in[i-1] == 1);
        end
    endgenerate

    
    generate
        for (i = 0;
 i < 100;
 i++) begin
            assign out_any[i] = (in[i] == 1) || (in[i+1] == 1);
        end
    endgenerate

    
    generate
        for (i = 0;
 i < 100;
 i++) begin
            assign out_different[i] = (in[i] != in[(i-1 + 100) % 100]);
        end
    endgenerate

endmodule
