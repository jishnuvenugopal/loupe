
module TopModule (
    input wire clk,
    input wire reset,
    output reg [31:0] q
);

    
    reg [31:0] lfsr = 32'h1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 32'h1;
        end else begin
            
            lfsr = {lfsr[31], lfsr[21] ^ lfsr[2] ^ lfsr[1]};
        end
    end

    
    assign q = lfsr;

endmodule
