
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out
);

    always @(*) begin
        if (a == 0 && b == 0) begin
            out = 1'b1;
        end else if (a == 1 && b == 1) begin
            out = 1'b1;
        end else if (a == 0 && b == 1) begin
            out = 1'b0;
        end else if (a == 1 && b == 0) begin
            out = 1'b0;
        end else if (d == 0) begin
            out = 1'b0;
        end else begin
            out = 1'b1;
        end
    end

endmodule
