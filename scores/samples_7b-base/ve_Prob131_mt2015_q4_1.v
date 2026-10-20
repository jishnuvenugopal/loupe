
module top_module(input x, input y, output z);
    wire b1_out, b2_out;
    wire a1_out, a2_out;
    wire or_out, and_out, xor_out;

    A a1(x, y, a1_out);
    A a2(x, y, a2_out);
    B b1(x, y, b1_out);
    B b2(x, y, b2_out);

    or_2 orgate(a1_out, b1_out, or_out);
    and_2 andgate(a2_out, b2_out, and_out);
    xor_2 xorgate(or_out, and_out, z);
endmodule

module or_2(input a, input b, output reg out);
    always @(*) begin
        out = a | b;
    end
endmodule

module and_2(input a, input b, output reg out);
    always @(*) begin
        out = a & b;
    end
endmodule

module xor_2(input a, input b, output reg out);
    always @(*) begin
        out = a ^ b;
    end
endmodule
