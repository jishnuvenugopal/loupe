
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
       


always @(posedge clk or posedge reset) begin
    if (reset) begin
        
        lfsr <= 32'h1;
    end else begin
        
        lfsr <= {lfsr[31:2], lfsr[30:22] ^ lfsr[21:18] ^ lfsr[17:14] ^ lfsr[13:10] ^ lfsr[9:6] ^ lfsr[5:2] ^ lfsr[1:0] ^ lfsr[0]};
    end
end


assign q = lfsr;

endmodule
