
module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output [2:0] out_or_logical,
    output [5:0] out_not_upper,
    output [5:0] out_not_lower
);

    
    assign out_or_bitwise = a | b;

    
    assign out_or_logical = a || b;

    
    assign out_not_upper = ~b;
    assign out_not_lower = ~a;

endmodule
