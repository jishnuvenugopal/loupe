
module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    reg q1, q2;

    always @(posedge clk) begin
        q1 <= d;
    end

    always @ (negedge clk) begin
        q2 <= d;
    end

    always @(*) begin
        q = q2;
    end

endmodule
