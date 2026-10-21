
module adder_16bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output reg [7:0] y,
    output reg Co
);

    
    genvar i;
    generate
        for (i = 0;
 i < 16;
 i = i + 1) begin :adder_instance
            adder_8bit u_adder (
                .A(a[i*8:i*8+7]),
                .B(b[i*8:i*8+7]),
                .Cin(Cin),
                .y(y[i*8:i*8+7]),
                .Co(Co)
            );
        end
    endgenerate

endmodule

module adder_8bit (
    input wire [7:0] A,
    input wire [7:0] B,
    input wire Cin,
    output reg [7:0] y,
    output reg Co
);

    
    reg [7:0] sum = A + B;

    
    reg [7:0] carry_in = Cin;

    
    assign Co = sum[7] | carry_in;

    
    assign y = sum[7:0];

endmodule
