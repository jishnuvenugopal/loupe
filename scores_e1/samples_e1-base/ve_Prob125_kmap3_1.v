
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    always @(*) begin
        if (a == 0 && b == 0) begin
            out = 0;
        end else if (a == 0 && b == 1) begin
            out = 1;
        end else if (a == 1 && b == 0) begin
            out = 1;
        end else if (a == 1 && b == 1) begin
            out = 1;
        end
    end

endmodule
