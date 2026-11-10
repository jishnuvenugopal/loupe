
module TopModule (
    input  wire [1:0] A,
    input  wire [1:0] B,
    output reg  z
);

    
    assign z = (A == B) ? 1'b1 : 1'b0;

endmodule
