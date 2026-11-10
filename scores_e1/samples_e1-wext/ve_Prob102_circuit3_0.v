
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg q
);

    always @(posedge a or posedge b or posedge c or posedge d) begin
        q <= a & b & c & d;
    end

endmodule
