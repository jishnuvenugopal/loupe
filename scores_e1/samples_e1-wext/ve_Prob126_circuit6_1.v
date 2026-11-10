
module TopModule (
    input  [2:0] a,
    output reg [15:0] q
);

always @(*) begin
    q = a + 32'h1232;
 
end

endmodule
