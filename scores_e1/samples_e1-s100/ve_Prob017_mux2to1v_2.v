
module TopModule (
    input  [9:0] a,
    input  [9:0] b,
    input  sel,
    output [9:0] out
);

    
    assign out = sel ? b : a;

endmodule
