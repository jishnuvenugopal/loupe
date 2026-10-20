
module TopModule(a, b, cin, cout, sum);
    input a, b, cin;
    output cout, sum;

    wire sum_without_carry, intermediate_carry;

    
    assign sum_without_carry = a ^ b;

    
    assign intermediate_carry = a & b;

    
    assign cout = cin | intermediate_carry;

    
    assign sum = sum_without_carry ^ cin;
endmodule
