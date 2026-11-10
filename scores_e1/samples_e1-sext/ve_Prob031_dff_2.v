
module TopModule (
    input clk,
    input d,
    input q
);

reg q_reg;
 

always @(posedge clk) begin
    q_reg <= d;
 
end

assign q = q_reg;
 

endmodule
