
module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    
    reg [31:0] lfsr = 32'h1;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 32'h1;
        end else begin
            
            reg [31:0] shifted_lfsr = {lfsr[31], lfsr[30:29], lfsr[28:27], lfsr[26:25], lfsr[24:23], lfsr[22:21], lfsr[20:19], lfsr[18:17], lfsr[16:15], lfsr[14:13], lfsr[12:11], lfsr[10:9], lfsr[8:7], lfsr[6:5], lfsr[4:3], lfsr[2:1], lfsr[0]};

            
            reg [31:0] tapped_lfsr = shifted_lfsr[32] ^ shifted_lfsr[22] ^ shifted_lfsr[2] ^ shifted_lfsr[1];

            
            lfsr <= tapped_lfsr;
        end
    end

    
    assign q = lfsr;

endmodule
