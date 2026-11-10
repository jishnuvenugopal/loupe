
module TopModule (
    input wire [4:0] a,
    input wire [4:0] b,
    input wire [4:0] c,
    input wire [4:0] d,
    input wire [4:0] e,
    input wire [4:0] f,
    output reg [7:0] w,
    output reg [7:0] x,
    output reg [7:0] y,
    output reg [7:0] z
);

    
    assign w = a[4:0] | b[4:0] | c[4:0] | d[4:0] | e[4:0] | f[4:0];

    
    assign x = w[7:4];
    assign y = w[3:0];
    assign z = w[1:0];

endmodule
