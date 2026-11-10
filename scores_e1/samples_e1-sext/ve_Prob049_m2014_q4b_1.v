
module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 0;
    end else begin
        if (d) begin
            q <= 1;
        end else begin
            q <= q;
        end
    end
end

endmodule
