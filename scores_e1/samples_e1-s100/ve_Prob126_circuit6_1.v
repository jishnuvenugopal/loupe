
module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    
    localparam CONSTANT = 16'h1232;

    
    assign q = a + CONSTANT;

endmodule
