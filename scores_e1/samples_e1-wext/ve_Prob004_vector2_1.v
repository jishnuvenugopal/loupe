
module TopModule (
    input wire [31:0] in,
    output reg [31:0] out
);

    always @(*) begin
        
        reg [7:0] byte0 = in[7:0];
        reg [7:0] byte1 = in[15:8];
        reg [7:0] byte2 = in[23:16];
        reg [7:0] byte3 = in[31:24];

        
        out = byte3 << 24 | byte2 << 16 | byte1 << 8 | byte0;
    end

endmodule
