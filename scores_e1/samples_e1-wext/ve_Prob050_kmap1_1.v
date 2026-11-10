
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    output reg out
);

always @(a, b, c) begin
    if (a == 0 && b == 1) begin
        out = 1'b1;
    end else begin
        out = 1'b0;
    end
end

endmodule

module TopModule_tb (
    input wire a,
    input wire b,
    input wire c,
    output reg out
);

reg a, b, c;
wire out;

TopModule dut (
    .a(a),
    .b(b),
    .c(c),
    .out(out)
);

initial begin
    a = 1'b0;
    b = 1'b1;
    c = 1'b0;
    #10;
    a = 1'b0;
    b = 1'b1;
    c = 1'b1;
    #10;
    a = 1'b1;
    b = 1'b1;
    c = 1'b1;
    #10;
    a = 1'b1;
    b = 1'b1;
    c = 1'b0;
    #10;
end

endmodule
