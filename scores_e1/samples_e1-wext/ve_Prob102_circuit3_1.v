
module TopModule (
    input wire a,
    input wire b,
    output reg q
);

    always @(a, b) begin
        q <= a & b;
    end

endmodule
