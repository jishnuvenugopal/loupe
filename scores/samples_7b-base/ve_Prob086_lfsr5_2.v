
module TopModule (
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] lfsr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        lfsr <= 5'b10000;
 
    end else begin
        lfsr[4:1] <= lfsr[3:0];
 
        lfsr[0] <= lfsr[4] ^ lfsr[2];
 
    end
end

assign q = lfsr;

endmodule
