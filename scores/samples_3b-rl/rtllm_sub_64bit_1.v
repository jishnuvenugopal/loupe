
module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output reg  [63:0] result,
    output wire        overflow
);

    
    assign result = A - B;

    
    
    
    assign overflow = (A > 0 && B < 0 && result < 0) || (A < 0 && B > 0 && result > 0);

endmodule
