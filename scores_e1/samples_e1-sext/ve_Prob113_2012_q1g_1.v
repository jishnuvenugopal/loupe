
module TopModule (
    input wire [3:0] x,
    output reg f
);

always @(*) begin
    if (x[0] == 0 && x[1] == 0) begin
        f = 1'b1;
    end else if (x[0] == 0 && x[1] == 1) begin
        f = 1'b0;
    end else if (x[0] == 1 && x[1] == 0) begin
        f = 1'b0;
    end else if (x[0] == 1 && x[1] == 1) begin
        f = 1'b1;
    end
end

endmodule
