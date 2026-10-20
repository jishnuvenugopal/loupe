
module TopModule (
    input  clk,
    input  reset,
    input  slowena,
    output reg [3:0] q
);


reg [3:0] count;


always @(posedge reset) begin
    count <= 4'b0000;
end


always @(posedge clk) begin
    if (slowena) begin
        count <= count + 1'b1;
    end
end


assign q = count;

endmodule
