
module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    
    adder_8bit adder1 (.a(a[7:0]), .b(b[7:0]), .Cin(Cin), .y(y[7:0]), .Co(Co1));
    adder_8bit adder2 (.a(a[15:8]), .b(b[15:8]), .Cin(Co1), .y(y[15:8]), .Co(Co2));

    
    assign Co = Co2;

endmodule


module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    
    wire [7:0] sum;
    wire Co;

    
    adder_4bit adder1 (.a(a[3:0]), .b(b[3:0]), .Cin(Cin), .y(sum[3:0]), .Co(Co1));
    adder_4bit adder2 (.a(a[7:4]), .b(b[7:4]), .Cin(Co1), .y(sum[7:4]), .Co(Co2));

    
    assign Co = Co2;

    
    assign y = sum;

endmodule


module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    
    wire [3:0] sum;
    wire Co;

    
    adder_2bit adder1 (.a(a[1:0]), .b(b[1:0]), .Cin(Cin), .y(sum[1:0]), .Co(Co1));
    adder_2bit adder2 (.a(a[3:2]), .b(b[3:2]), .Cin(Co1), .y(sum[3:2]), .Co(Co2));

    
    assign Co = Co2;

    
    assign y = sum;

endmodule


module adder_2bit (
    input [1:0] a,
    input [1:0] b,
    input Cin,
    output [1:0] y,
    output Co
);

    
    wire [1:0] sum;
    wire Co;

    
    adder_1bit adder1 (.a(a[0]), .b(b[0]), .Cin(Cin), .y(sum[0]), .Co(Co1));
    adder_1bit adder2 (.a(a[1]), .b(b[1]), .Cin(Co1), .y(sum[1]), .Co(Co2));

    
    assign y = sum;

endmodule


module adder_1bit (
    input a,
    input b,
    input Cin,
    output y,
    output Co
);

    
    wire sum;
    wire Co;

    
    always @(*) begin
        case ({a, b, Cin})
            4'b0000: {sum, Co} = 2'b00;
            4'b0001: {sum, Co} = 2'b01;
            4'b0010: {sum, Co} = 2'b10;
            4'b0011: {sum, Co} = 2'b11;
            4'b0100: {sum, Co} = 2'b01;
            4'b0101: {sum, Co} = 2'b10;
            4'b0110: {sum, Co} = 2'b11;
            4'b0111: {sum, Co} = 2'b00;
            4'b1000: {sum, Co} = 2'b10;
            4'b1001: {sum, Co} = 2'b11;
            4'b1010: {sum, Co} = 2'b00;
            4'b1011: {sum, Co} = 2'b01;
            4'b1100: {sum, Co} = 2'b11;
            4'b1101: {sum, Co} = 2'b00;
            4'b1110: {sum, Co} = 2'b01;
            4'b1111: {sum, Co} = 2'b10;
            default: {sum, Co} = 2'b00;
        endcase
    end

    
    assign y = sum;

endmodule
