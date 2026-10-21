
module TopModule (
    input  wire [31:0] in,
    output wire [31:0] out
);

    
    wire [7:0] chunk1 = in[7:0];
    wire [7:0] chunk2 = in[15:8];
    wire [7:0] chunk3 = in[23:16];
    wire [7:0] chunk4 = in[31:24];

    
    wire [7:0] reversed_chunk1 = chunk4;
    wire [7:0] reversed_chunk2 = chunk3;
    wire [7:0] reversed_chunk3 = chunk2;
    wire [7:0] reversed_chunk4 = chunk1;

    
    assign out = reversed_chunk1 << 24 | reversed_chunk2 << 16 | reversed_chunk3 << 8 | reversed_chunk4;

endmodule
