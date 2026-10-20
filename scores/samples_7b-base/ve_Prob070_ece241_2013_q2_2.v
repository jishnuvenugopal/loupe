
module top_module(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire out_sop,
    output wire out_pos
);

    wire sop_expression;
    wire pos_expression;

    
    assign sop_expression = (~c & ~d & ~b) | (~c & d) | (c & d & ~a);

    
    assign pos_expression = (a | c | d) & (~a | ~b) & (~b | d);

    
    assign out_sop = sop_expression;
    assign out_pos = pos_expression;

endmodule
