
module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);
    reg [2:0] count;

    always @(posedge clk) begin
        if (a == 1) begin
            count <= 0;
  
        end else begin
            count <= count + 1;
  
        end
        q <= count;
  
    end
endmodule
