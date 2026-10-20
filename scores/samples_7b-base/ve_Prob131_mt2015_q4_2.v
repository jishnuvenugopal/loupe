
module top_module(
    input x,
    input y,
    output z
);
    wire a1_out, a2_out, b1_out, b2_out, or_out, and_out, xor_out;

    
    module A(A_in, B_in, Z_out);
        input A_in, B_in;
        output Z_out;

        assign Z_out = (A_in ^ B_in) & A_in;
    endmodule

    
    A a1 (.A_in(x), .B_in(y), .Z_out(a1_out));

    
    module B(B_in, Z_out);
        input B_in;
        output Z_out;

        assign Z_out = (B_in) ? 1 : 0;
    endmodule

    
    B b1 (.B_in(y), .Z_out(b1_out));

    
    assign or_out = a1_out | b1_out;

    
    assign and_out = a2_out & b2_out;

    
    A a2 (.A_in(x), .B_in(y), .Z_out(a2_out));

    
    B b2 (.B_in(y), .Z_out(b2_out));

    
    assign xor_out = or_out ^ and_out;

    assign z = xor_out;
endmodule
