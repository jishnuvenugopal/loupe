
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    
    adder_8bit adder1 (.a(a[7:0]), .b(b[7:0]), .Cin(Cin), .y(y[7:0]), .Co(Co1));
    adder_8bit adder2 (.a(a[15:8]), .b(b[15:8]), .Cin(Co1), .y(y[15:8]), .Co(Co2));

    
    assign Co = Co1 | Co2;

endmodule


module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    
    wire C;

    
    adder_4bit adder1 (.a(a[3:0]), .b(b[3:0]), .Cin(Cin), .y(y[3:0]), .Co(C));
    adder_4bit adder2 (.a(a[7:4]), .b(b[7:4]), .Cin(C), .y(y[7:4]), .Co(Co));

endmodule


module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    
    wire C;

    
    adder_2bit adder1 (.a(a[1:0]), .b(b[1:0]), .Cin(Cin), .y(y[1:0]), .Co(C));
    adder_2bit adder2 (.a(a[3:2]), .b(b[3:2]), .Cin(C), .y(y[3:2]), .Co(Co));

endmodule


module adder_2bit(
    input [1:0] a,
    input [1:0] b,
    input Cin,
    output [1:0] y,
    output Co
);

    
    wire C;

    
    adder_1bit adder1 (.a(a[0]), .b(b[0]), .Cin(Cin), .y(y[0]), .Co(C));
    adder_1bit adder2 (.a(a[1]), .b(b[1]), .Cin(C), .y(y[1]), .Co(Co));

endmodule


module adder_1bit(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);

    
    wire C;

    
    assign y = a ^ b ^ Cin;

    
    assign Co = (a & b) | (Cin & (a ^ b));

endmodule
