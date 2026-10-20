
module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);


reg [3:0] count;


always @(posedge reset) begin
    count <= 4'b0000;
 
end


always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
 
    end else begin
        count <= count + 1;
 
    end
end


assign q = count;

endmodule
