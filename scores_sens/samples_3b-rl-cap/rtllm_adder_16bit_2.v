
module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input        Cin,
    output [15:0] y,
    output       Co
);

    wire [8:0] sum1, sum2;
    wire [8:0] sum3;
    wire       c1, c2;

    
    assign sum1 = a[7:0] + b[7:0] + Cin;
    assign c1   = sum1[8];

    
    assign sum2 = a[15:8] + b[15:8] + c1;
    assign c2   = sum2[8];

    
    assign sum3 = sum2[7:0] + c2;
    assign Co   = sum3[8];

    
    assign y[7:0] = sum1[7:0];
    assign y[15:8] = sum2[7:0];

endmodule
