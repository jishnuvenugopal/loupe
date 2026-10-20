
module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        
        q <= {q[30:0], 1'b0};
    end
end

endmodule
