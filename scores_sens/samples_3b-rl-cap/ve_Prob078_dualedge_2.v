
module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    reg q1, q2;

    always @(posedge clk or negedge clk) begin
        if (!clk)
            q1 <= 1'b0;
        else
            q1 <= d;

        q2 <= q1;
    end

    assign q = q2;

endmodule
