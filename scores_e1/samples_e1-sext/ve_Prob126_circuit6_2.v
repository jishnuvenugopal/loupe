
module TopModule (
    input  wire [2:0] a,  
    output reg [15:0] q   
);

always @(posedge a) begin
    q <= q + 1;
  
end

endmodule
