
module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire cin,
    output wire [15:0] sum,
    output wire cout
);
    wire [7:0] s[15:0];
    wire [7:0] c;

    
    for (genvar i = 0;
 i < 16;
 i = i + 1) begin
        adder_8bit adder (
            .a(a[i*8:(i+1)*8]),
            .b(b[i*8:(i+1)*8]),
            .cin(cout),
            .s(s[i*8:(i+1)*8]),
            .cout(c)
        );
    end

    
    assign sum = s[15:0] + c;
    assign cout = c;
endmodule
