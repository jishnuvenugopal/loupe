
module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output reg [7:0] w,
    output reg [7:0] x,
    output reg [7:0] y,
    output reg [7:0] z
);

    
    wire [29:0] input_concatenated;

    assign input_concatenated = a[4:0] | b[4:0] | c[4:0] | d[4:0] | e[4:0] | f[4:0];

    
    assign w = input_concatenated[7:0];
    assign x = input_concatenated[15:8];
    assign y = input_concatenated[23:16];
    assign z = input_concatenated[31:24];

endmodule
