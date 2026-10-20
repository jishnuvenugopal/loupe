
module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    
    reg [7:0] carry_in;
    reg [7:0] carry_out;

    
    generate
        for (genvar i = 0;
 i < 8;
 i = i + 1) begin
            full_adder #(.N(1)) fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry_in[i]),
                .sum(s[i]),
                .cout(carry_out[i])
            );
        end
    endgenerate

    
    assign carry_in[7] = carry_out[7];

    
    assign overflow = carry_in[7] & carry_out[7];

endmodule


module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule
