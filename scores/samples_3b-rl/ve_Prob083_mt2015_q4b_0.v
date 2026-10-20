
module TopModule (
    input x,
    input y,
    output reg z
);

always @(*) begin
    if (x == 1 && y == 1) begin
        z = 1;
    end else begin
        z = 0;
    end
end




initial begin
    $display("time  x  y  z");
    $monitor("%gns %b %b %b");
    $finish;
end

endmodule
