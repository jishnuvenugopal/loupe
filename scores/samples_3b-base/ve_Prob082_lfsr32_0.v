
module TopModule (
    input  clk,
    input  reset,
    output reg [31:0] q
);


reg [31:0] lfsr = 32'h1;


parameter TAP_32 = 32'h80000000;
 
parameter TAP_22 = 32'h4000000;
  
parameter TAP_2  = 32'h2;
       
parameter TAP_1  = 32'h1;
       


always @(posedge clk or posedge reset) begin
    if (reset) begin
        
        lfsr <= 32'h1;
    end else begin
        
        lfsr <= lfsr ^ TAP_32 ^ TAP_22 ^ TAP_2 ^ TAP_1;
    end
end


assign q = lfsr;

endmodule
