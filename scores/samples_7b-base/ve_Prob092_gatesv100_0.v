
module top_module(input [99:0] in, output [99:0] out_both, output [99:0] out_any, output [99:0] out_different);
    assign out_both[99] = 0;
    assign out_any[0] = 0;
    assign out_different[99] = in[99] != in[0];

    genvar i;
    generate
        for(i = 0;
 i < 99;
 i = i + 1) begin : out_both_loop
            assign out_both[i] = in[i] & in[i+1];
        end

        for(i = 0;
 i < 99;
 i = i + 1) begin : out_any_loop
            assign out_any[i] = in[i] | in[i+1];
        end

        for(i = 0;
 i < 99;
 i = i + 1) begin : out_different_loop
            assign out_different[i] = in[i] != in[i+1];
        end
    endgenerate
endmodule
