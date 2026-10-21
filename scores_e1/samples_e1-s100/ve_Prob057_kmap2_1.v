
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    always @(*) begin
        if ((a && b) || (c && d)) begin
            out = 1'b1;
        end else begin
            out = 1'b0;
        end
    end

endmodule
