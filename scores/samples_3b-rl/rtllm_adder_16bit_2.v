
module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input        Cin,
    output [15:0] y,
    output       Co
);

    wire [15:0] sum;
    wire [16:0] sum17;

    
    assign sum17[15:0] = a[15:8] + b[15:8] + 1'b0;
    
    assign sum17[23:16] = a[7:0] + b[7:0] + 1'b0;
    
    assign sum17[16] = sum17[15:0] + sum17[23:16] > 16'd15? 1'b1: 1'b0;
    assign sum = sum17[15:0] + sum17[23:16];

    assign y = sum;
    assign Co = sum17[16];

endmodule
