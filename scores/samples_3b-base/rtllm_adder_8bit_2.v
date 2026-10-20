
module adder_8bit (
    input [7:0] a, 
    input [7:0] b, 
    input cin,     
    output [7:0] sum, 
    output cout    
);

    
    wire [7:0] carry;
    wire [7:0] sum_temp;

    
    generate
        for (genvar i = 0;
 i < 8;
 i = i + 1) begin
            
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(cin),
                .sum(sum_temp[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    
    assign sum = sum_temp;
    assign cout = carry[7];

endmodule


module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    
    wire s, c;

    
    assign s = a ^ b ^ cin;
    assign c = (a & b) | (a & cin) | (b & cin);

    
    assign sum = s;
    assign cout = c;

endmodule
