
module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg s0, s1, s2, s3;

    always @(posedge clk) begin
        if (!resetn) begin
            s0 <= 1'b0;
            s1 <= 1'b0;
            s2 <= 1'b0;
            s3 <= 1'b0;
        end else begin
            s0 <= in;
            s1 <= s0;
            s2 <= s1;
            s3 <= s2;
        end
    end

    assign out = s3;

endmodule
