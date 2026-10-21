
module TopModule (
    input wire a,
    output wire q
);

    always @(a) begin
        if (a) begin
            q <= 0;
        end else begin
            q <= 1;
        end
    end

endmodule
