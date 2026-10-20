
module TopModule (
    output zero
);

    reg zero;

    always @(*) begin
        zero = 1'b0;
    end

endmodule
