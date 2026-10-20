
module A (input x, y, output z);
    assign z = (x ^ y) & x;
endmodule

module B (input x, y, output z);
    assign z = (x == 0 && y == 0) || (x == 1 && y == 1);
endmodule

module top_module (input x, y, output z);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;
    
    A A1 (.x(x), .y(y), .z(a1_out));
    A A2 (.x(x), .y(y), .z(a2_out));
    B B1 (.x(x), .y(y), .z(b1_out));
    B B2 (.x(x), .y(y), .z(b2_out));
    
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    assign z = or_out ^ and_out;
endmodule
