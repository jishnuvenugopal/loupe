
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg q
);

    always @(a, b, c, d) begin
        if (a && b && c && d) begin
            q <= 1;
        end else if (a && b && c) begin
            q <= 1;
        end else if (a && b) begin
            q <= 1;
        end else if (a) begin
            q <= 1;
        end else if (b) begin
            q <= 1;
        end else if (c) begin
            q <= 1;
        end else if (d) begin
            q <= 1;
        end else begin
            q <= 0;
        end
    end

endmodule
