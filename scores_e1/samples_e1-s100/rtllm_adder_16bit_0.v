
module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output reg [15:0] y,
    output reg Co
);

    
    genvar i;
    generate
        for (i = 0;
 i < 16;
 i = i + 1) begin
            adder_8bit #(.WIDTH(8)) adder (
                .a(a[i*8:(i*8+7)]),
                .b(b[i*8:(i*8+7)]),
                .Cin(Cin),
                .s(y[i*8:(i*8+7)]),
                .Co(Co[i])
            );
        end
    endgenerate

endmodule
