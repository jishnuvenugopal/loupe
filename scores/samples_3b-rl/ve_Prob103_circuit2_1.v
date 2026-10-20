
module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);

    
    wire two_ones;
    wire three_ones;
    wire all_ones;

    
    wire two_ones_and;
    assign two_ones_and = (a & b & ~c & ~d) | (~a & ~b & c & d) | (a & c & ~b & ~d);
    assign two_ones = two_ones_and;

    
    assign three_ones = a & b & c & ~d;

    
    assign all_ones = a & b & c & d;

    
    assign q = two_ones | three_ones;

endmodule
