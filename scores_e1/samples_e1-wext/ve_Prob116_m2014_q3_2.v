
module TopModule (
    input wire [3:0] x,
    output reg f
);

    
    localparam d = 4'b1111;

    
    assign f = ((x[1] & x[2]) | (x[1] & ~x[2])) ^ d;

endmodule
