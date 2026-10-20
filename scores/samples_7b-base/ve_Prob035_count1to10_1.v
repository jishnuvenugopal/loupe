
module TopModule(
    input wire clk,
    input wire reset,
    output reg [3:0] q
);

reg [3:0] counter;

reg [3:0] next_state;

always @(posedge clk or posedge reset) begin
    if (reset)
        counter <= 4'b0000;
 
    else
        counter <= next_state;
 
end

always @(*) begin
    if (counter == 4'b1001) 
        next_state = 4'b0000;
 
    else
        next_state = counter + 1;
 
end

assign q = counter + 1;
 

endmodule
