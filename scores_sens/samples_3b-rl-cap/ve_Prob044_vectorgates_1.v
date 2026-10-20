
module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output [2:0] out_or_logical,
    output [5:0] out_not
);

    
    assign out_or_bitwise = a | b;

    
    assign out_or_logical = {3'b0, a | b};

    
    assign out_not = {~b, ~a};

endmodule
