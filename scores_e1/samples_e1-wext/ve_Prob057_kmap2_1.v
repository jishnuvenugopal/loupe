
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out
);

    always @(*) begin
        out = a & b & c & d;
    end

endmodule
