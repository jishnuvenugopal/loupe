
module TopModule (
    input wire clk,
    input wire reset,
    output reg [4:0] q
);

    
    localparam N = 5;
 
    localparam TAP1 = 5;
 
    localparam TAP2 = 3;
 

    
    reg [N-1:0] lfsr = 5'b10101;
 

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 5'b10101;
 
            q <= 5'b1;
 
        end else begin
            
            reg [N-1:0] next_lfsr = lfsr;
            next_lfsr[TAP1] = lfsr[TAP1] ^ lfsr[TAP2];
            next_lfsr[TAP2] = lfsr[TAP2] ^ lfsr[N-1];
            lfsr <= next_lfsr;

            
            q <= lfsr[N-1];
        end
    end

endmodule
