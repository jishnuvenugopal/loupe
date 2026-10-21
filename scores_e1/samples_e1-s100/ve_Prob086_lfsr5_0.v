
module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    
    reg [4:0] lfsr = 5'b10101;
 

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 5'b10101;
 
        end else begin
            
            lfsr = {lfsr[4], lfsr[3], lfsr[2], lfsr[1], lfsr[0] ^ lfsr[4] ^ lfsr[3]};
        end
    end

    
    assign q = lfsr;

endmodule
