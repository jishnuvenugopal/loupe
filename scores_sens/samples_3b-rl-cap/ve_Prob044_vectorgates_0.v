
module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    wire [2:0] or_result;
    wire or_logical;
    wire [2:0] not_a;
    wire [2:0] not_b;

    
    assign or_result = a | b;

    
    assign or_logical = or_result;

    
    assign not_a = ~a;
    assign not_b = ~b;

    
    assign out_not[5:3] = not_b;
    assign out_not[2:0] = not_a;

endmodule
