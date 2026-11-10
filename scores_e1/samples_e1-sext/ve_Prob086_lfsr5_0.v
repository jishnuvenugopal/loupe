
module TopModule (
    input wire clk,
    input wire reset,
    output reg [4:0] q
);

    
    reg [4:0] lfsr = 5'b10101;
 

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 5'b10101;
 
        end else begin
            
            reg [4:0] next_lfsr = lfsr[4] ^ lfsr[3];
            next_lfsr = next_lfsr ^ lfsr[2];
            next_lfsr = next_lfsr ^ lfsr[1];
            next_lfsr = next_lfsr ^ lfsr[0];
            lfsr <= next_lfsr;
        end
    end

    
    assign q = lfsr;

endmodule
