
module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback = q[0];
reg [31:0] next_q;

always @(*) begin
    next_q = { q[30:0], 1'b0 };
 
    next_q[31] = feedback;
       
    next_q[21] = next_q[21] ^ feedback;
 
    next_q[1]  = next_q[1] ^ feedback;
    next_q[0]  = next_q[0] ^ feedback;
end

always @(posedge clk) begin
    if (reset)
        q <= 32'h1;
    else
        q <= next_q;
end

endmodule
