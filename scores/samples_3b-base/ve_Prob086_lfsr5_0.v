
module TopModule (
    input  clk,
    input  reset,
    output reg [4:0] q
);

    
    localparam TAP_5 = 5'b10000;
 
    localparam TAP_3 = 5'b00100;
 

    
    reg [4:0] lfsr;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            
            lfsr <= 5'b11111;
        end else begin
            
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[TAP_5] ^ lfsr[TAP_3]};
        end
    end

    
    assign q = lfsr;

endmodule
