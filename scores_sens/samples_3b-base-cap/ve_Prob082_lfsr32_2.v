
module TopModule (
    input  clk,
    input  reset,
    output reg [31:0] q
);


reg [31:0] lfsr = 32'h1;


parameter TAP_32 = 32'h80000000;
 
parameter TAP_22 = 32'h4000000;
  
parameter TAP_2  = 32'h4;
       
parameter TAP_1  = 32'h1;
       

always @(posedge clk) begin
    
    if (reset) begin
        lfsr <= 32'h1;
    end else begin
        
        lfsr <= {lfsr[31:2], lfsr[31:2] ^ lfsr[22], lfsr[31:2] ^ lfsr[2], lfsr[31:2] ^ lfsr[1]};
    end
end


assign q = lfsr;

endmodule
