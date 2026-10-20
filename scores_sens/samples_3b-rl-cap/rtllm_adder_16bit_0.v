
module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input        Cin,
    output [15:0] y,
    output       Co
);

    wire [7:0] c1, c2, c3;

    
    assign y[7:0] = a[7:0] + b[7:0] + Cin;
    assign c1     = a[7] + b[7] + Cin;

    
    assign y[15:8] = a[15:8] + b[15:8] + c1;
    assign c2     = a[15] + b[15] + c1;

    
    assign y[23:16] = a[23:16] + b[23:16] + c2;
    assign c3     = a[23] + b[23] + c2;

    
    assign y[31:24] = a[31:24] + b[31:24] + c3;
    assign Co       = a[31] + b[31] + c3;

endmodule
