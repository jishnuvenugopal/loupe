
module TopModule (
    input  clk,
    input  reset,
    output reg [4:0] q
);

    
    parameter TAP_5 = 5'b10000;
 
    parameter TAP_3 = 5'b01000;
 

    
    reg [4:0] lfsr;

    
    always @(posedge reset) begin
        lfsr <= 5'b11111;
 
    end

    
    always @(posedge clk) begin
        
        lfsr <= {lfsr[4:0], lfsr[TAP_5] ^ lfsr[TAP_3]};
    end

    
    assign q = lfsr;

endmodule
