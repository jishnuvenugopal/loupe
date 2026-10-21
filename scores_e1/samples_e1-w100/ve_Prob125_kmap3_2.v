
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out
);

    
    localparam MINTERMS = 8'h0000;
    localparam DONTCARES = 8'h0000;

    
    assign out = (a & b & c & d) | (a & b & c & ~d) | (a & b & ~c & d) | (a & b & ~c & ~d) | (a & ~b & c & d) | (a & ~b & c & ~d) | (a & ~b & ~c & d) | (a & ~b & ~c & ~d);

endmodule
