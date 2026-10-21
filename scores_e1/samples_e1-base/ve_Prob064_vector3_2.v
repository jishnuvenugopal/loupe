
module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    
    wire [29:0] concatenated_input;

    assign concatenated_input = a | (b << 5) | (c << 10) | (d << 15) | (e << 20) | (f << 25);

    
    assign w = concatenated_input[29:24];
    assign x = concatenated_input[23:18];
    assign y = concatenated_input[17:12];
    assign z = concatenated_input[11:6];

    
    assign w = w | 2'b11;
    assign x = x | 2'b11;
    assign y = y | 2'b11;
    assign z = z | 2'b11;

endmodule
