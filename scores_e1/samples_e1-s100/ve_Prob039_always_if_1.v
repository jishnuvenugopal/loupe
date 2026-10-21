
module TopModule_tb (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output reg out_assign,
    output reg out_always
);

reg a, b, sel_b1, sel_b2;
wire out_assign, out_always;

TopModule top_module (
    .a(a),
    .b(b),
    .sel_b1(sel_b1),
    .sel_b2(sel_b2),
    .out_assign(out_assign),
    .out_always(out_always)
);

initial begin
    a = 1'b0;
    b = 1'b1;
    sel_b1 = 1'b0;
    sel_b2 = 1'b0;
    #10;
    a = 1'b1;
    b = 1'b0;
    sel_b1 = 1'b0;
    sel_b2 = 1'b1;
    #10;
    a = 1'b0;
    b = 1'b1;
    sel_b1 = 1'b1;
    sel_b2 = 1'b0;
    #10;
    a = 1'b1;
    b = 1'b1;
    sel_b1 = 1'b1;
    sel_b2 = 1'b1;
    #10;
end

endmodule
