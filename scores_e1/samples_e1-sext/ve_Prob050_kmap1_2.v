
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    output reg out
);

    always @(*) begin
        if (a == 0 && b == 1 && c == 1) begin
            out = 1'b1;
        end else begin
            out = 1'b0;
        end
    end

endmodule
