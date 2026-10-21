
module TopModule (
    input a,
    input b,
    output reg out_and,
    output reg out_or,
    output reg out_xor,
    output reg out_nand,
    output reg out_nor,
    output reg out_xnor,
    output reg out_anotb
);

    
    assign out_and = a & b;
    assign out_or = a | b;
    assign out_xor = a ^ b;
    assign out_nand = ~a & b;
    assign out_nor = ~a | b;
    assign out_xnor = ~a ^ b;
    assign out_anotb = a & ~b;

endmodule
