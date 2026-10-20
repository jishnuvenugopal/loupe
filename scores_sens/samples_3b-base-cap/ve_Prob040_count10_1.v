
module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);


reg [3:0] d_ff0, d_ff1, d_ff2, d_ff3;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        d_ff0 <= 4'b0000;
        d_ff1 <= 4'b0000;
        d_ff2 <= 4'b0000;
        d_ff3 <= 4'b0000;
    end else begin
        
        d_ff0 <= d_ff1;
        d_ff1 <= d_ff2;
        d_ff2 <= d_ff3;
        d_ff3 <= d_ff3 + 1'b1;
    end
end


assign q = d_ff3;

endmodule
