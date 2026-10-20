
module TopModule (
    input clk,
    input a,
    output reg q
);

reg [1:0] count;

always @(posedge clk) begin
    if (a == 1) begin
        count <= count;
  
    end else begin
        count <= count + 1;
        if (count == 3) begin
            q <= ~q;
  
            count <= 0;
  
        end
    end
end

endmodule
