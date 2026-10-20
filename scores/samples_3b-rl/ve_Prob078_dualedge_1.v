
module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    reg [1:0] q2;

    always @(posedge clk or negedge clk) begin
        if (clk) begin
            q2 <= {q2[1], d};
        end else begin
            q2 <= {d, q2[0]};
        end
    end

    assign q = q2[0];

endmodule
