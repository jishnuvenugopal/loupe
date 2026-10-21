
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
 i = i + 1) begin
            adder_8bit #(.WIDTH(8)) adder (
                .a(a[i*8:i*8+7]),
                .b(b[i*8:i*8+7]),
                .Cin(Cin),
                .y(y[i*8:i*8+7]),
                .Co(Co[i])
            );
        end
    endgenerate

endmodule

module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output reg [7:0] y,
    output reg Co
);

    
    assign y = a + b;

    
    assign Co = (y >= 256) ? 1'b1 : 1'b0;
    assign y = y - Co * 256;

endmodule
