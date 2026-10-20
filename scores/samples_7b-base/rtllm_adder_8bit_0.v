
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output reg [7:0] sum,
    output reg cout
);


module full_adder (
    input a,
    input b,
    input cin,
    output reg sum,
    output reg cout
);
    assign {sum, cout} = a + b + cin;
endmodule


genvar i;
generate
    for (i = 0;
 i < 8;
 i = i + 1) begin : full_adder_loop
        full_adder fa (
            .a(a[i]),
            .b(b[i]),
            .cin(i == 0 ? cin : sum[i-1]), 
            .sum(sum[i]),
            .cout(cout[i])
        );
    end
endgenerate

endmodule
