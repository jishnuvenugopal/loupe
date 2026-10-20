
module top_module (
    input  x,
    input  y,
    output z
);
    
    wire a1_out, a2_out, b1_out, b2_out;
    wire or_out, and_out, xor_out;

    
    A a1 (.x(x), .y(y), .z(a1_out));
    A a2 (.x(x), .y(y), .z(a2_out));

    
    B b1 (.x(x), .y(y), .z(b1_out));
    B b2 (.x(x), .y(y), .z(b2_out));

    
    or or_gate (.a(a1_out), .b(b1_out), .y(or_out));

    
    and and_gate (.a(a2_out), .b(b2_out), .y(and_out));

    
    xor xor_gate (.a(or_out), .b(and_out), .y(z));

endmodule


module A (
    input  x,
    input  y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module B (
    input  x,
    input  y,
    output z
);
    
    always @(x or y) begin
        case ({x, y})
            2'b00: z = 1'b1;
            2'b01: z = 1'b0;
            2'b10: z = 1'b0;
            2'b11: z = 1'b1;
        endcase
    end
endmodule
