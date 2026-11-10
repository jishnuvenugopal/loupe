
module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    
    reg [15:0] flip_flops [0:15];

    
    assign flip_flops[0] = d[15:8];
    assign flip_flops[1] = d[7:0];
    assign flip_flops[2] = d[15:8];
    assign flip_flops[3] = d[7:0];
    assign flip_flops[4] = d[15:8];
    assign flip_flops[5] = d[7:0];
    assign flip_flops[6] = d[15:8];
    assign flip_flops[7] = d[7:0];
    assign flip_flops[8] = d[15:8];
    assign flip_flops[9] = d[7:0];
    assign flip_flops[10] = d[15:8];
    assign flip_flops[11] = d[7:0];
    assign flip_flops[12] = d[15:8];
    assign flip_flops[13] = d[7:0];
    assign flip_flops[14] = d[15:8];
    assign flip_flops[15] = d[7:0];

    
    assign q = flip_flops[byteena[1]] | flip_flops[byteena[0]];

endmodule
