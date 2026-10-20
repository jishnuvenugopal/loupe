
module TopModule (
    input  clk,
    input  reset,
    output reg [31:0] q
);


reg [31:0] lfsr = 32'h1;


localparam TAP_32 = 32'h80000000;
 
localparam TAP_22 = 32'h40000000;
 
localparam TAP_2 = 32'h00000004;
  
localparam TAP_1 = 32'h00000001;
  


always @(posedge clk or posedge reset) begin
    if (reset) begin
        
        lfsr <= 32'h1;
    end else begin
        
        lfsr <= {lfsr[31:2], lfsr[30:22] ^ lfsr[21:18] ^ lfsr[17:14] ^ lfsr[13:10] ^ lfsr[9:6] ^ lfsr[5:2] ^ lfsr[1:0] ^ lfsr[0]};
    end
end


assign q = lfsr;

endmodule
