
module top_module (
    input wire clk,
    input wire reset,
    output reg [4:0] q
);

    reg [4:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 5'b00001;
 
        end else begin
            lfsr <= {lfsr[3], lfsr[2], lfsr[1], lfsr[0], (lfsr[0] ^ lfsr[4])};
        end
    end

    assign q = lfsr;

endmodule
