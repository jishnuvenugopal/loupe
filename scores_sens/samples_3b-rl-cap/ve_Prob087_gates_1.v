
module TopModule (
    input  a,
    input  b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    wire and_out;
    wire or_out;
    wire xor_out;
    wire nand_out;
    wire nor_out;
    wire xnor_out;
    wire anotb_out;

    assign and_out = a & b;
    assign or_out = a | b;
    assign xor_out = a ^ b;
    assign nand_out = ~(a & b);
    assign nor_out = ~(a | b);
    assign xnor_out = ~(a ^ b);
    assign anotb_out = a & ~b;

    assign out_and = and_out;
    assign out_or = or_out;
    assign out_xor = xor_out;
    assign out_nand = nand_out;
    assign out_nor = nor_out;
    assign out_xnor = xnor_out;
    assign out_anotb = anotb_out;

endmodule
