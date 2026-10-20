
module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output reg  [24:0] out
);

    integer i, j;

    always @(*) begin
        for (i = 0;
 i < 5;
 i = i + 1) begin
            for (j = 0;
 j < 5;
 j = j + 1) begin
                out[(i*5)+j] = ~a ^ b;
            end
        end
    end

endmodule
