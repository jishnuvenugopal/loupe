
module TopModule (
    input  d,
    input  ena,
    output q
);

always @(posedge ena or posedge d) begin
    q <= d;
end

endmodule
