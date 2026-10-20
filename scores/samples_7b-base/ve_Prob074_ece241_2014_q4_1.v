
module TopModule(
    input clk,
    input x,
    output z
);
    reg q1, q2, q3;

    wire xor_out = x ^ q1;
    wire and_out = x & ~q2;
    wire or_out = x | ~q3;

    always @(posedge clk) begin
        q1 <= xor_out;
        q2 <= and_out;
        q3 <= or_out;
    end

    assign z = q1 & ~q2 & ~q3;
endmodule
