
module TopModule(
    input  clk,
    input  d,
    input  r,
    output q
);

reg q_dff;
 

always @(posedge clk or posedge r) begin
    if (r) begin
        q_dff <= 0;
 
    end else begin
        q_dff <= d;
 
    end
end

assign q = q_dff;
 

endmodule
