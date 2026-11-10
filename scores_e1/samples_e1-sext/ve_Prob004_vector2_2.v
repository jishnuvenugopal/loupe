
module TopModule (
    input wire [31:0] in,
    output reg [31:0] out
);

    always @(*) begin
        
        reg [7:0] part1 = in[7:0];
        reg [7:0] part2 = in[15:8];
        reg [7:0] part3 = in[23:16];
        reg [7:0] part4 = in[31:24];

        
        reg [7:0] reversedPart1 = part4;
        reg [7:0] reversedPart2 = part3;
        reg [7:0] reversedPart3 = part2;
        reg [7:0] reversedPart4 = part1;

        
        out = reversedPart1 << 24 | reversedPart2 << 16 | reversedPart3 << 8 | reversedPart4;
    end

endmodule
