
module TopModule (
    input wire clk,
    input wire reset,
    output reg [9:0] q
);


reg [9:0] counter = 10'b0000000000;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 10'b0000000000;
 
    end else begin
        counter <= counter + 1;
 
    end
end

assign q = counter;
 

endmodule
