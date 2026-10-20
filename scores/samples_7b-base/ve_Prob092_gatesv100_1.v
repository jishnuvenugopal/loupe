
module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;

    
    assign out_both[99] = 0;
    generate
        for (i = 0;
 i < 99;
 i = i + 1) begin : both_loop
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate

    
    assign out_any[0] = 0;
    generate
        for (i = 1;
 i < 100;
 i = i + 1) begin : any_loop
            assign out_any[i] = in[i-1] | in[i];
        end
    endgenerate

    
    generate
        for (i = 0;
 i < 99;
 i = i + 1) begin : different_loop
            assign out_different[i] = in[i] ^ in[i+1];
        end
    endgenerate
    assign out_different[99] = in[99] ^ in[0];

endmodule
