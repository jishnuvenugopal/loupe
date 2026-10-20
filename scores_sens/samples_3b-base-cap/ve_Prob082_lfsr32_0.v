
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
        
        lfsr <= {lfsr[31:2], lfsr[21:2], lfsr[19:2], lfsr[18:2], lfsr[17:2], lfsr[16:2], lfsr[15:2], lfsr[14:2], lfsr[13:2], lfsr[12:2], lfsr[11:2], lfsr[10:2], lfsr[9:2], lfsr[8:2], lfsr[7:2], lfsr[6:2], lfsr[5:2], lfsr[4:2], lfsr[3:2], lfsr[2:2], lfsr[1:2], lfsr[0] ^ lfsr[31] ^ lfsr[21] ^ lfsr[2] ^ lfsr[1]};
    end
end


assign q = lfsr;

endmodule
