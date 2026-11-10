
module top_module (
    input wire x,
    input wire y,
    output reg z
);


module A (
    input wire x,
    input wire y,
    output reg z
);

    assign z = (x ^ y) & x;

endmodule


module B (
    input wire x,
    input wire y,
    output reg z
);

    assign z = (x ^ y) & x;

endmodule


assign top_module.A[0].x = x;
assign top_module.A[0].y = y;
assign top_module.A[0].z = top_module.A[0].z;

assign top_module.A[1].x = x;
assign top_module.A[1].y = y;
assign top_module.A[1].z = top_module.A[1].z;

assign top_module.B[0].x = x;
assign top_module.B[0].y = y;
assign top_module.B[0].z = top_module.B[0].z;

assign top_module.B[1].x = x;
assign top_module.B[1].y = y;
assign top_module.B[1].z = top_module.B[1].z;

assign top_module.A[2].x = x;
assign top_module.A[2].y = y;
assign top_module.A[2].z = top_module.A[2].z;

assign top_module.A[3].x = x;
assign top_module.A[3].y = y;
assign top_module.A[3].z = top_module.A[3].z;

assign top_module.B[2].x = x;
assign top_module.B[2].y = y;
assign top_module.B[2].z = top_module.B[2].z;

assign top_module.B[3].x = x;
assign top_module.B[3].y = y;
assign top_module.B[3].z = top_module.B[3].z;

assign top_module.A[0].z = top_module.A[0].z | top_module.B[0].z;
assign top_module.A[1].z = top_module.A[1].z | top_module.B[1].z;
assign top_module.A[2].z = top_module.A[2].z | top_module.B[2].z;
assign top_module.A[3].z = top_module.A[3].z | top_module.B[3].z;

assign top_module.A[0].z = top_module.A[0].z & top_module.B[0].z;
assign top_module.A[1].z = top_module.A[1].z & top_module.B[1].z;
assign top_module.A[2].z = top_module.A[2].z & top_module.B[2].z;
assign top_module.A[3].z = top_module.A[3].z & top_module.B[3].z;

assign z = top_module.A[0].z ^ top_module.A[1].z ^ top_module.A[2].z ^ top_module.A[3].z;

endmodule
