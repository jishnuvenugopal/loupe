
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] y,
    output cout
);
    wire [7:0] c;
    
    assign y[0] = a[0] ^ b[0] ^ cin;
    assign c[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
    
    genvar i;
    generate
        for (i = 1;
 i < 8;
 i = i + 1) begin : adder_loop
            assign y[i] = a[i] ^ b[i] ^ c[i-1];
            assign c[i] = (a[i] & b[i]) | (a[i] & c[i-1]) | (b[i] & c[i-1]);
        end
    endgenerate
    
    assign cout = c[7];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire Co1;
    
    adder_8bit lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .y(y[7:0]),
        .cout(Co1)
    );
    
    adder_8bit upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(Co1),
        .y(y[15:8]),
        .cout(Co)
    );
endmodule
