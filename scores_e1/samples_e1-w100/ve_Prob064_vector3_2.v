
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

    assign concatenated_input = a[4:0] | b[4:0] | c[4:0] | d[4:0] | e[4:0] | f[4:0];

    
    wire [7:0] w_split;
    wire [7:0] x_split;
    wire [7:0] y_split;
    wire [7:0] z_split;

    assign w_split = concatenated_input[29:24];
    assign x_split = concatenated_input[23:18];
    assign y_split = concatenated_input[17:12];
    assign z_split = concatenated_input[11:6];

    
    assign w = w_split | 2'b11;
    assign x = x_split | 2'b11;
    assign y = y_split | 2'b11;
    assign z = z_split | 2'b11;

endmodule
