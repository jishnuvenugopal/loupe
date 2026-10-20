
module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

localparam mask = 5'b10100;
 

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
 
    else
        q <= (q << 1) ^ ( {5{ q[4] }} & mask );
end

endmodule
