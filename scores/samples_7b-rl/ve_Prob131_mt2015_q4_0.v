
module top (input x, input y, output z);
    wire A_out1, B_out1;
    wire A_out2, B_out2;
    wire or_out, and_out;

    A a_inst1 (.x(x), .y(y), .z(A_out1));
    A a_inst2 (.x(x), .y(y), .z(A_out2));
    B b_inst1 (.x(x), .y(y), .z(B_out1));
    B b_inst2 (.x(x), .y(y), .z(B_out2));

    assign or_out = A_out1 | B_out1;
    assign and_out = A_out2 & B_out2;
    
    assign z = or_out ^ and_out;
endmodule

module A (input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

module B (input x, input y, output z);
    assign z = (x == y);
endmodule
