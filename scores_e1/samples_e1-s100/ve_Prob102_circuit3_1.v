
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    always_comb begin
        q = a & b | c & d;
    end

endmodule
