
module TopModule (
  input wire clk,
  input wire reset,
  output reg [9:0] q
);


reg [9:0] counter;


always @(posedge clk or posedge reset) begin
  if (reset) begin
    counter <= 10'd0;
 
  end else begin
    counter <= counter + 1;
 
    if (counter == 10'd999) begin
      counter <= 10'd0;
 
    end
  end
end


assign q = counter;

endmodule
